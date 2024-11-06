import SwiftUI

struct ContentView: View {
    @State private var selection: Selection = .launches
    @State private var launchId: String?
    @State private var preferredColumn = NavigationSplitViewColumn.sidebar
    private var theme = ThemeManager()

    enum Selection {
        case launches
        case news
    }

    var body: some View {
        TabView(selection: $selection) {
            Tab("Launches", image: "rocket-template-tiny", value: Selection.launches) {
                LaunchesView(
                    launchId: $launchId,
                    preferredColumn: $preferredColumn
                )
                .environmentObject(theme)
            }
            Tab("News", systemImage: "newspaper", value: Selection.news) {
                NewsView()
                    .environmentObject(theme)
            }
        }
        .tabViewStyle(.automatic)
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
