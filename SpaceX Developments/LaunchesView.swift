//
//  LaunchesView.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 27/09/2024.
//

import SwiftUI

struct LaunchesView: View {
    @StateObject private var themeManager = ThemeManager()

    var body: some View {
        NavigationSplitView {
            VStack(alignment: .leading, spacing: 32) {
                CountdownView()
                    .environmentObject(themeManager)
                    .padding(-8)

                NextLaunchView()
                    .environmentObject(themeManager)
                    .padding(-8)

                Spacer()
            }
            .padding()
        } detail: {
            Text("Select a launch")
        }
    }
}

#Preview {
    LaunchesView().environmentObject(ThemeManager())
}
