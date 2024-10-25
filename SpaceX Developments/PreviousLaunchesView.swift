import SwiftUI

struct PreviousLaunchesView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var viewModel: LaunchViewModel
    @Binding var launchId: String?
    @Binding var preferredCompactColumn: NavigationSplitViewColumn

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Previous launches")
                    .font(.title2)

                Spacer()
            }

            if let launches = viewModel.previousLaunches {
                ForEach(launches) { launch in
                    VStack {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Name")
                                        .font(.headline)

                                    Text(launch.name)
                                        .font(.subheadline)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                Spacer()

                                Button {
                                    launchId = launch.id
                                    preferredCompactColumn = .detail
                                } label: {
                                    Image("rocket-template")
                                    Text("Details")
                                }
                                .buttonStyle(.borderedProminent)
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
                        .padding(.bottom, 24)
                        .background(themeManager.selectedTheme.cardColor)
                    }
                    .padding(.bottom, 1)
                    .background(themeManager.selectedTheme.listDividerColor)
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
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    PreviousLaunchesView(
        viewModel: LaunchViewModel(),
        launchId: .constant(nil),
        preferredCompactColumn: .constant(NavigationSplitViewColumn.sidebar)
    )
    .environmentObject(ThemeManager())
}
