import SwiftUI

struct ContentView: View {
    @State private var selection: Selection = .nextLaunch
    @State private var launchId: String?
    @State private var preferredColumn = NavigationSplitViewColumn.sidebar
    private var themeManager = ThemeManager()

    var body: some View {
        TabView(selection: $selection) {
            Tab("Next Launch", image: "rocket-template-tiny", value: Selection.nextLaunch) {
                NextLaunchView(
                    tabSelection: $selection,
                    launchId: $launchId,
                    preferredColumn: $preferredColumn
                )
                .environmentObject(themeManager)
            }

            Tab("Launches", systemImage: "list.bullet", value: Selection.launches) {
                LaunchesView(
                    launchId: $launchId,
                    preferredColumn: $preferredColumn
                )
                .environmentObject(themeManager)
            }

            Tab("News", systemImage: "newspaper", value: Selection.news) {
                NewsView()
                    .environmentObject(themeManager)
            }

            Tab("Settings", systemImage: "gear", value: Selection.settings) {
                EmptyView()
                    .environmentObject(themeManager)
            }
        }
        .onOpenURL { url in
            guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                debugPrint("Invalid URL: \(url.absoluteString)")
                return
            }

            if let id = urlComponents.queryItems?.first(where: { $0.name == "id" })?.value {
                selection = .launches
                launchId = id
                preferredColumn = .detail
            } else if urlComponents.path.isEmpty {
                selection = .launches
                preferredColumn = .sidebar
            }
        }
    }
}

#Preview {
    ContentView()
}
