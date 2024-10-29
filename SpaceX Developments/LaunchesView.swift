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
                #if !os(watchOS)
                    .listRowSeparator(.hidden)
                #endif
                    .padding(.horizontal, -8)
                    .buttonStyle(.plain) // TODO: remove?

                NextLaunchView(
                    viewModel: viewModel,
                    launchId: $launchId,
                    preferredCompactColumn: $preferredColumn
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
                    preferredCompactColumn: $preferredColumn
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
            #endif
            .refreshable {
                viewModel.getNextLaunch(ignoreCache: true)
                viewModel.getPreviousLaunches(ignoreCache: true)
            }
            .navigationTitle("Launches")
            .onOpenURL { url in
                guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                    debugPrint("Invalid URL: \(url.absoluteString)")
                    return
                }

                if let id = urlComponents.queryItems?.first(where: { $0.name == "id" })?.value {
                    launchId = id
                    preferredColumn = .detail
                } else if urlComponents.path.isEmpty {
                    preferredColumn = .sidebar
                }
            }
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
