//
//  NextLaunchViewModel.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 01/10/2024.
//

import Foundation

class NextLaunchViewModel: ObservableObject {
    let api = SpaceXApiService()
    var countdown: Timer?
    @Published var nextLaunch: NextLaunch?
    @Published var timeLeft: Int?

    init() {
        getNextLaunch()
    }

    func getLaunchDate() -> String? {
        guard let nextLaunch else { return nil }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")

        if nextLaunch.netPrecision == .hour {
            formatter.setLocalizedDateFormatFromTemplate("MMMdyh")
        }

        if nextLaunch.netPrecision == .minute {
            formatter.setLocalizedDateFormatFromTemplate("MMMdyhm")
        }

        if nextLaunch.netPrecision == .second {
            formatter.setLocalizedDateFormatFromTemplate("MMMdyhms")
        }

        return formatter.string(from: nextLaunch.net)
    }

    private func getNextLaunch() {
        api.getNextLaunch { (result: Result<NextLaunch, AppError>) in
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
}