//
//  LaunchDetailsViewModel.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 01/10/2024.
//

import Foundation
import SwiftUI

class LaunchDetailsViewModel: ObservableObject {
    @Published var launchDetails: LaunchDetails?
    @StateObject var appState = AppState.singleton

    func getLaunchDetails(for launchId: String) {
        debugPrint("getLaunchDetails(for: \(launchId))")
        appState.api.getLaunchDetails(for: launchId) { (result: Result<LaunchDetails, AppError>) in
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
