import Foundation
import SwiftUI

class LaunchDetailsViewModel: ObservableObject {
    @Published var launchDetails: LaunchDetails?

    func getLaunchDetails(for launchId: String, ignoreCache: Bool) async {
        let result = await StellarApexApp.state.apiService.getLaunchDetails(for: launchId, ignoreCache: ignoreCache)

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
