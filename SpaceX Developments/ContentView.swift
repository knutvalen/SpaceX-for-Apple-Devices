import SwiftUI

struct ContentView: View {
    @State private var selection: Selection = .launches

    enum Selection {
        case launches
        case news
    }

    var body: some View {
        TabView(selection: $selection) {
            Tab("Launches", image: "rocket-template", value: Selection.launches) {
                LaunchesView()
            }
            Tab("News", systemImage: "newspaper", value: Selection.launches) {
                NewsView()
            }
        }
        .tabViewStyle(.automatic)
    }
}

#Preview {
    ContentView()
}
