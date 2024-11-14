import Foundation
import SwiftUI

@MainActor
class LaunchViewModel: ObservableObject {
    var countdown: Timer?
    @Published var nextLaunch: LaunchDetails?
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

    func getNextLaunch(ignoreCache: Bool) async {
        let result = await StellarApexApp.state.apiService.getNextLaunch(ignoreCache: ignoreCache)

        switch result {
        case let .success(nextLaunch):
            let nowTime = Date().timeIntervalSince1970

            guard let nextLaunchTime = nextLaunch.net?.timeIntervalSince1970 else {
                return debugPrint("No next launch time")
            }

            let timeLeft = Int(floor(nextLaunchTime - nowTime))

            self.nextLaunch = nextLaunch
            self.timeLeft = timeLeft
            countdown?.invalidate()

            countdown = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                DispatchQueue.main.async {
                    if self.timeLeft != nil {
                        self.timeLeft! -= 1
                    }
                }
            }

        case let .failure(error):
            debugPrint(error)
        }
    }

    func getPreviousLaunches(ignoreCache: Bool) async {
        let result = await StellarApexApp.state.apiService.getPreviousLaunches(ignoreCache: ignoreCache)

        switch result {
        case let .success(launches):
            let launchServiceProviders = Set(launches.map(\.launchServiceProvider)).sorted()

            do {
                try await saveLaunchServiceProviders(launchServiceProviders: launchServiceProviders)
            } catch {
                fatalError(error.localizedDescription)
            }

            previousLaunches = launches

        case let .failure(error):
            debugPrint(error)
        }
    }
}
