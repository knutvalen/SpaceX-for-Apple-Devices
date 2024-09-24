import Foundation
import SwiftUI

class LaunchDetailsViewModel: ObservableObject {
    @Published var launchDetails: LaunchDetails?
    @StateObject var appState = AppState.singleton

    func getLaunchDetails(for launchId: String, ignoreCache: Bool) {
        appState.api.getLaunchDetails(for: launchId, ignoreCache: ignoreCache) { (result: Result<LaunchDetails, AppError>) in
            switch result {
            case let .success(launchDetails):
                DispatchQueue.main.async {
                    self.launchDetails = launchDetails
                }
            case let .failure(error):
                debugPrint(error)
            }
        }
    }
}
