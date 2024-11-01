import SwiftUI

struct ContentView: View {
    @State private var selection: Selection = .launches
    @State private var launchId: String?
    @State private var preferredColumn = NavigationSplitViewColumn.sidebar

    enum Selection {
        case launches
        case news
    }

    var body: some View {
        TabView(selection: $selection) {
            Tab("Launches", image: "rocket-tiny-template", value: Selection.launches) {
                LaunchesView(
                    launchId: $launchId,
                    preferredColumn: $preferredColumn
                )
                .environmentObject(ThemeManager())
            }
            Tab("News", systemImage: "newspaper", value: Selection.news) {
                NewsView()
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
