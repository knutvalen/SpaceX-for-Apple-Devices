import Foundation
import SwiftUI

class LaunchViewModel: ObservableObject {
    @StateObject var appState = AppState.singleton
    var countdown: Timer?
    @Published var nextLaunch: LaunchOverview?
    @Published var timeLeft: Int?
    let initialLimit = 10
    var limit: Int
    @Published var previousLaunches: [LaunchOverview]?

    init() {
        limit = initialLimit
        getNextLaunch(ignoreCache: false)
        getPreviousLaunches(ignoreCache: false)
    }

    func getNextLaunch(ignoreCache: Bool) {
        countdown?.invalidate()
        timeLeft = nil

        appState.api.getNextLaunch(ignoreCache: ignoreCache) { (result: Result<LaunchOverview, AppError>) in
            switch result {
            case let .success(nextLaunch):

                let nowTime = Date().timeIntervalSince1970
                let nextLaunchTime = nextLaunch.net.timeIntervalSince1970
                let timeLeft = Int(floor(nextLaunchTime - nowTime))

                DispatchQueue.main.async {
                    self.nextLaunch = nextLaunch
                    self.timeLeft = timeLeft

                    self.countdown = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        if self.timeLeft != nil {
                            if self.timeLeft! > 0 {
                                self.timeLeft! -= 1
                            } else {
                                self.countdown?.invalidate()
                            }
                        }
                    }
                }

            case let .failure(error):
                debugPrint(error)
            }
        }
    }

    func loadMore() {
        limit += initialLimit
        getPreviousLaunches(ignoreCache: false)
    }

    func getPreviousLaunches(ignoreCache: Bool) {
        appState.api.getPreviousLaunches(limit: limit, ignoreCache: ignoreCache) { (result: Result<[LaunchOverview], AppError>) in
            switch result {
            case let .success(launches):
                DispatchQueue.main.async {
                    self.previousLaunches = launches
                }

            case let .failure(error):
                debugPrint(error)
            }
        }
    }
}
