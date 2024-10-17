//
//  PreviousLaunchesView.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 10/10/2024.
//

import SwiftUI

struct PreviousLaunchesView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var viewModel: LaunchViewModel
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            HStack {}
                .padding(16)
                .background(themeManager.selectedTheme.cardColor)
                .cornerRadius(12)
                .shadow(color: themeManager.selectedTheme.shadowColor, radius: 2, x: 1, y: 2)
        }
    }
}

#Preview {
    PreviousLaunchesView(viewModel: .init())
        .environmentObject(ThemeManager())
}
