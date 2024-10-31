import SwiftUI

struct LaunchesView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject private var viewModel = LaunchViewModel()
    @Binding var launchId: String?
    @Binding var preferredColumn: NavigationSplitViewColumn

    var body: some View {
        NavigationSplitView(preferredCompactColumn: $preferredColumn) {
            List {
                CountdownView(viewModel: viewModel)
                    .environmentObject(themeManager)
                #if !os(watchOS)
                    .listRowSeparator(.hidden)
                #endif
                    .padding(.horizontal, -8)
                    .buttonStyle(.plain) // TODO: remove?

                NextLaunchView(
                    viewModel: viewModel,
                    launchId: $launchId,
                    preferredColumn: $preferredColumn
                )
                .environmentObject(themeManager)
                #if !os(watchOS)
                    .listRowSeparator(.hidden)
                #endif
                    .padding(.horizontal, -8)
                    .buttonStyle(.plain)

                PreviousLaunchesView(
                    viewModel: viewModel,
                    launchId: $launchId,
                    preferredColumn: $preferredColumn
                )
                .environmentObject(themeManager)
                #if !os(watchOS)
                    .listRowSeparator(.hidden)
                #endif
                    .padding(.horizontal, -8)
                    .buttonStyle(.plain)
            }
            #if !os(watchOS)
            .listStyle(.inset)
            .listRowSpacing(32)
            #endif
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
                    ContentUnavailableView("Select a launch", image: "rocket-tiny-template")
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
