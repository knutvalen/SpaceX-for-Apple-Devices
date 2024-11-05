import Foundation
import SwiftUI

@MainActor
class LaunchViewModel: ObservableObject {
    @StateObject var appState = AppState.singleton
    var countdown: Timer?
    @Published var nextLaunch: LaunchOverview?
    @Published var timeLeft: Int?
    @Published var previousLaunches: [LaunchOverview]?

    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("LaunchServiceProviders")
    }

    func saveLaunchServiceProviders(launchServiceProviders: [LaunchServiceProvider]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(launchServiceProviders)
            let fileURL = try Self.fileURL()
            try data.write(to: fileURL)
        }
        _ = try await task.value
    }

    init() {
        Task {
            await getNextLaunch(ignoreCache: false)
            await getPreviousLaunches(ignoreCache: false)
            await getNextLaunch(ignoreCache: true)
            await getPreviousLaunches(ignoreCache: true)
        }
    }

    func getNextLaunch(ignoreCache: Bool) async {
        let result = await appState.api.getNextLaunch(ignoreCache: ignoreCache)

        switch result {
        case let .success(nextLaunch):
            let nowTime = Date().timeIntervalSince1970
            let nextLaunchTime = nextLaunch.net.timeIntervalSince1970
            let timeLeft = Int(floor(nextLaunchTime - nowTime))

//            DispatchQueue.main.async {
            self.nextLaunch = nextLaunch
            self.timeLeft = timeLeft
            countdown?.invalidate()

            countdown = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                DispatchQueue.main.async {
                    if self.timeLeft != nil {
                        if self.timeLeft! > 0 {
                            self.timeLeft! -= 1
                        } else {
                            self.countdown?.invalidate()
                        }
                    }
                }
//                }
            }

        case let .failure(error):
            debugPrint(error)
        }
    }

    func getPreviousLaunches(ignoreCache: Bool) async {
        let result = await appState.api.getPreviousLaunches(ignoreCache: ignoreCache)

        switch result {
        case let .success(launches):
            let launchServiceProviders = Set(launches.map(\.launchServiceProvider)).sorted()

            do {
                try await saveLaunchServiceProviders(launchServiceProviders: launchServiceProviders)
            } catch {
                fatalError(error.localizedDescription)
            }

//            DispatchQueue.main.async {
            previousLaunches = launches
//            }

        case let .failure(error):
            debugPrint(error)
        }
    }
}
