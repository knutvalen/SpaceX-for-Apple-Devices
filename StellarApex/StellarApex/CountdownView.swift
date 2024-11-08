import CachedAsyncImage
import SwiftUI

struct CountdownView: View {
    @ObservedObject var viewModel: LaunchViewModel

    var body: some View {
        if let launch = viewModel.nextLaunch,
           let timeLeft = viewModel.timeLeft
        {
            HStack {
                if let imageURL = launch.patches?.first?.imageURL {
                    CachedAsyncImage(url: URL(string: imageURL)) { phase in
                        switch phase {
                        case let .success(image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 64, height: 64)

                        case .failure:
                            EmptyView()

                        case .empty:
                            ProgressView()
                                .controlSize(.small)
                                .frame(width: 64, height: 64)

                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                VStack(alignment: .leading) {
                    Text(formatCountdown(secondsLeft: timeLeft))

                        .font(.largeTitle)

                    if let launchDate = launch.net?.toStellarApexDateString() {
                        Text(launchDate)
                            .font(.caption)
                    }
                }
            }
        } else {
            ProgressView().onAppear {
                Task {
                    await viewModel.getNextLaunch(ignoreCache: false)
                }
            }
        }
    }
}

private func formatCountdown(secondsLeft: Int) -> String {
    var hours = secondsLeft / (60 * 60)
    var minutes = (secondsLeft % (60 * 60)) / 60
    var seconds = secondsLeft % 60
    let prefix: String

    if secondsLeft > 0 {
        prefix = "T-"
    } else {
        prefix = "T+"
        hours.negate()
        minutes.negate()
        seconds.negate()
    }

    let hPrefix = hours < 10 ? "0" : ""
    let mPrefix = minutes < 10 ? "0" : ""
    let sPrefix = seconds < 10 ? "0" : ""

    return "\(prefix)\(hPrefix)\(hours):\(mPrefix)\(minutes):\(sPrefix)\(seconds)"
}

#Preview {
    CountdownView(viewModel: LaunchViewModel())
}
