//
//  ThemeManager.swift
//  SpaceX Launches
//
//  Created by Knut Valen on 18/09/2024.
//

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
