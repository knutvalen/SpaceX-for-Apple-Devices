//
//  ContentView.swift
//  SpaceX Launches
//
//  Created by Knut Valen on 16/09/2024.
//

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
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
