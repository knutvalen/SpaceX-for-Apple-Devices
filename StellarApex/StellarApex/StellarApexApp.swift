import SwiftUI

@main
struct StellarApexApp: App {
    static let state = AppState()
    static let fakeDataSource = FakeDataSource()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
