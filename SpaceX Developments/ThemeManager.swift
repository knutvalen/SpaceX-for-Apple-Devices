import SwiftUI

/**
 Theme Manager
 */
class ThemeManager: ObservableObject {
    @Published var selectedTheme: ThemeProtocol = MainTheme()

    func setTheme(_ theme: ThemeProtocol) {
        selectedTheme = theme
    }
}
