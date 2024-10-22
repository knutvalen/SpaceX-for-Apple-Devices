import SwiftUI

struct NextLaunchView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var viewModel: LaunchViewModel
    @Binding var selected: String?
    @Binding var preferredCompactColumn: NavigationSplitViewColumn

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Next launch")
                    .font(.title2)

                Spacer()

                if let launch = viewModel.nextLaunch {
                    Button {
                        selected = launch.id
                        preferredCompactColumn = .detail
                    } label: {
                        Text("Details")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }

            if let launch = viewModel.nextLaunch {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Name")
                                .font(.headline)

                            Text(launch.name)
                                .font(.subheadline)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    if let launchDate = launch.net.toLaunch(precision: launch.netPrecision) {
                        VStack(alignment: .leading) {
                            Text("Launch date")
                                .font(.headline)

                            Text(launchDate)
                                .font(.subheadline)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
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
    }
}

#Preview {
    NextLaunchView(
        viewModel: LaunchViewModel(),
        selected: .constant(nil),
        preferredCompactColumn: .constant(NavigationSplitViewColumn.sidebar)
    )
    .environmentObject(ThemeManager())
}
