import SwiftUI

struct LaunchesView: View {
    private var themeManager = ThemeManager()
    @ObservedObject private var viewModel = LaunchViewModel()
    @State private var launchId: String?
    @State private var preferredColumn = NavigationSplitViewColumn.sidebar

    var body: some View {
        NavigationSplitView(preferredCompactColumn: $preferredColumn) {
            List {
                CountdownView(viewModel: viewModel)
                    .environmentObject(themeManager)
                    .listRowSeparator(.hidden)
                    .padding(.horizontal, -16)
                    .buttonStyle(.plain)

                NextLaunchView(
                    viewModel: viewModel,
                    selected: $launchId,
                    preferredCompactColumn: $preferredColumn
                )
                .environmentObject(themeManager)
                .listRowSeparator(.hidden)
                .padding(.horizontal, -16)
                .buttonStyle(.plain)

                PreviousLaunchesView(
                    viewModel: viewModel,
                    selected: $launchId,
                    preferredCompactColumn: $preferredColumn
                )
                .environmentObject(themeManager)
                .listRowSeparator(.hidden)
                .padding(.horizontal, -16)
                .buttonStyle(.plain)
            }
            .listStyle(.inset)
            .refreshable {
                viewModel.getNextLaunch(ignoreCache: true)
                viewModel.getPreviousLaunches(ignoreCache: true)
            }
            .navigationTitle("Launches")
        } detail: {
            ZStack {
                if let id = Binding($launchId) {
                    LaunchDetailsView(launchId: id)
                } else {
                    ContentUnavailableView("Select a launch", image: "rocket-template")
                }
            }
        }
    }
}

#Preview {
    LaunchesView()
        .environmentObject(ThemeManager())
}
