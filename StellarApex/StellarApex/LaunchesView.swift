import SwiftUI

struct LaunchesView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject private var viewModel = LaunchViewModel()
    @Binding var launchId: String?
    @Binding var preferredColumn: NavigationSplitViewColumn
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        if let launches = viewModel.previousLaunches {
            NavigationSplitView(preferredCompactColumn: $preferredColumn) {
                List(launches) { launch in
                    Button {
                        launchId = launch.id
                        preferredColumn = .detail
                    } label: {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(launch.name)
                                .font(.headline)
                                .fixedSize(horizontal: false, vertical: true)

                            if let launchDate = launch.net.toStellarApexDateString() {
                                Text(launchDate)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .refreshable {
                    await viewModel.getPreviousLaunches(ignoreCache: true)
                }
                .navigationTitle("Launches")
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active && viewModel.previousLaunches != nil {
                        Task {
                            await viewModel.getPreviousLaunches(ignoreCache: false)
                        }
                    }
                }
            } detail: {
                ZStack {
                    if let id = Binding($launchId) {
                        LaunchDetailsView(launchId: id)
                    } else {
                        ContentUnavailableView("Select a launch", image: "rocket-template-1x")
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
            .onAppear {
                Task {
                    await viewModel.getPreviousLaunches(ignoreCache: false)
                }
            }
        }
    }
}

#Preview {
    LaunchesView(
        launchId: .constant(nil),
        preferredColumn: .constant(NavigationSplitViewColumn.sidebar)
    )
    .environmentObject(ThemeManager())
}
