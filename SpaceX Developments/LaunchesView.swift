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
            List {
                CountdownView()
                    .environmentObject(themeManager)
                    .listRowSeparator(.hidden)
                    .padding(.horizontal, -16)
                
                NextLaunchView()
                    .environmentObject(themeManager)
                    .listRowSeparator(.hidden)
                    .padding(.horizontal, -16)
                    
            }
            .listStyle(.inset)
            .navigationTitle("Launches")
        } detail: {
            Text("Select a launch")
        }
    }
}

#Preview {
    LaunchesView().environmentObject(ThemeManager())
}
