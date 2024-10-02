//
//  CountdownView.swift
//  SpaceX Launches
//
//  Created by Knut Valen on 17/09/2024.
//

import Foundation
import SwiftUI

struct CountdownView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject private var viewModel = NextLaunchViewModel()

    var body: some View {
        HStack {
            if viewModel.timeLeft == nil {
                Spacer()
                ProgressView()
                Spacer()
            }

            if let timeInSeconds = viewModel.timeLeft {
                VStack(alignment: .leading, spacing: 16) {
                    if let name = viewModel.nextLaunch?.name {
                        Text(name)
                            .font(.title2)
                    } else {
                        Text("Countdown to next launch")
                            .font(.title2)
                    }

                    Text(formatCountdown(timeInSeconds: timeInSeconds))
                        .font(.largeTitle)
                }

                Spacer()
            }
        }
        .padding(12)
        .background(themeManager.selectedTheme.cardColor)
        .cornerRadius(12)
        .shadow(color: themeManager.selectedTheme.shadowColor, radius: 2, x: 1, y: 2)
    }
}

private func formatCountdown(timeInSeconds: Int) -> String {
    if timeInSeconds <= 0 {
        if let past = Calendar.current.date(
            byAdding: .second,
            value: timeInSeconds,
            to: Date()
        ) {
            return "Launched \(past.formatted(.relative(presentation: .named)))"
        }

        return "Launched"
    }

    let days = timeInSeconds / (60 * 60 * 24)
    let hours = (timeInSeconds % (60 * 60 * 24)) / (60 * 60)
    let minutes = (timeInSeconds % (60 * 60)) / 60
    let seconds = timeInSeconds % 60
    return "\(days)d \(hours)h \(minutes)m \(seconds)s"
}

#Preview {
    CountdownView().environmentObject(ThemeManager())
}
