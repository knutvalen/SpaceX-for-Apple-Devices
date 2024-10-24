import Foundation
import SwiftUI

struct CountdownView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var viewModel: LaunchViewModel
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VStack {
            if let launch = viewModel.nextLaunch {
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(launch.name)
                            .font(.title2)

                        if let timeInSeconds = viewModel.timeLeft {
                            Text(formatCountdown(timeInSeconds: timeInSeconds))
                                .font(.largeTitle)
                                .bold()
                        } else {
                            ProgressView()
                                .controlSize(.large)
                        }
                    }

                    Spacer()
                }
            } else {
                HStack {
                    Spacer()

                    ProgressView()
                        .controlSize(.large)

                    Spacer()
                }
            }
        }
        .padding(16)
        .background(themeManager.selectedTheme.cardColor)
        .cornerRadius(12)
        .shadow(color: themeManager.selectedTheme.shadowColor, radius: 2, x: 1, y: 2)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active && viewModel.timeLeft != nil {
                viewModel.getNextLaunch(ignoreCache: false)
            }
        }
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
    CountdownView(viewModel: .init())
        .environmentObject(ThemeManager())
}
