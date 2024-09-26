//
//  CountdownViewModel.swift
//  SpaceX Launches
//
//  Created by Knut Valen on 23/09/2024.
//

import Foundation
import SwiftUI

class CountdownViewModel: ObservableObject {
    var api = SpaceXApiService()
    var countdown: Timer?
    @Published var timeLeft: Int?

    init() {
        api.getNextLaunch { (result: Result<NextLaunch, AppError>) in
            switch result {
            case let .success(nextLaunch):
                debugPrint("nextLaunch: \(nextLaunch)")
                let nowTime = Date().timeIntervalSince1970
                let nextLaunchTime = nextLaunch.net.timeIntervalSince1970
                DispatchQueue.main.async {
                    let timeLeft = Int(floor(nextLaunchTime - nowTime))
                    debugPrint(timeLeft)
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
}
