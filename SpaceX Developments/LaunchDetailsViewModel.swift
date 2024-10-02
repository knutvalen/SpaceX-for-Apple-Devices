//
//  LaunchDetailsViewModel.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 01/10/2024.
//

import Foundation

class LaunchDetailsViewModel: ObservableObject {
    let api = SpaceXApiService()
//    private let launchId: String
    @Published var launchDetails: LaunchDetails?

    init(launchId: String) {
        getLaunchDetails(for: launchId)
    }

    func getLaunchDetails(for launchId: String) {
        api.getLaunchDetails(for: launchId) { (result: Result<LaunchDetails, AppError>) in
            switch result {
            case let .success(launchDetails):
                self.launchDetails = launchDetails
                debugPrint(launchDetails)
            case let .failure(error):
                debugPrint(error)
            }
        }
    }
}
