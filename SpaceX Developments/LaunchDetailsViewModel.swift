//
//  LaunchDetailsViewModel.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 01/10/2024.
//

import Foundation

class LaunchDetailsViewModel: ObservableObject {
    let api = SpaceXApiService()
    @Published var launchDetails: LaunchDetails?

    func getLaunchDetails(for launchId: String) {
        debugPrint("getLaunchDetails(for: \(launchId))")
        api.getLaunchDetails(for: launchId) { (result: Result<LaunchDetails, AppError>) in
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
