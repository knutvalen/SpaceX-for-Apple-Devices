import SwiftUI

struct LaunchesView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject private var viewModel = LaunchViewModel()
    @Binding var launchId: String?
    @Binding var preferredColumn: NavigationSplitViewColumn
    @State private var displayingSettings: Bool = false
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        NavigationSplitView(preferredCompactColumn: $preferredColumn) {
            List {
                CountdownView(viewModel: viewModel)
                    .environmentObject(themeManager)
                #if !os(watchOS)
                    .listRowSeparator(.hidden)
                #endif

                NextLaunchView(viewModel: viewModel, launchId: $launchId, preferredColumn: $preferredColumn)
                    .environmentObject(themeManager)
                #if !os(watchOS)
                    .listRowSeparator(.hidden)
                #endif

                PreviousLaunchesView(viewModel: viewModel, launchId: $launchId, preferredColumn: $preferredColumn)
                    .environmentObject(themeManager)
                #if !os(watchOS)
                    .listRowSeparator(.hidden)
                #endif
            }
            #if !os(watchOS)
            .listStyle(.inset)
            .listRowSpacing(32)
            #endif
            .padding(.horizontal, -8)
            .refreshable {
                await viewModel.getNextLaunch(ignoreCache: true)
                await viewModel.getPreviousLaunches(ignoreCache: true)
            }
            .navigationTitle("Launches")
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active && viewModel.timeLeft != nil {
                    Task {
                        await viewModel.getNextLaunch(ignoreCache: false)
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
    }
}

#Preview {
    LaunchesView(
        launchId: .constant(nil),
        preferredColumn: .constant(NavigationSplitViewColumn.sidebar)
    )
    .environmentObject(ThemeManager())
}
