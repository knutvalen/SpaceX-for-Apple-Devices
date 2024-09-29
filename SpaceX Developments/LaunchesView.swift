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
            Text("SpaceX Launches").font(.largeTitle)
            
            List {
                CountdownView()
                    .environmentObject(themeManager)
                
                NextLaunchView()
            }
        } detail: {
            Text("Select a launch")
        }
    }
}

#Preview {
    LaunchesView().environmentObject(ThemeManager())
}
