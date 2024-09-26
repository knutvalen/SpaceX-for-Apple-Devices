//
//  ContentView.swift
//  SpaceX Launches
//
//  Created by Knut Valen on 16/09/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var themeManager = ThemeManager()

    var body: some View {
        NavigationSplitView {
            List {
                CountdownView()
                    .environmentObject(themeManager)
            }
        } detail: {
            Text("Select a launch")
        }
    }
}

#Preview {
    ContentView()
}
