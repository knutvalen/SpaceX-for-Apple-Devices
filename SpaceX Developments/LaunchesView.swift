//
//  LaunchesView.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 27/09/2024.
//

import SwiftUI

struct LaunchesView: View {
    private var themeManager = ThemeManager()
    @ObservedObject private var viewModel = LaunchViewModel()
    @State private var selected: String?
    @State private var preferredColumn = NavigationSplitViewColumn.sidebar

    var body: some View {
        NavigationSplitView(preferredCompactColumn: $preferredColumn) {
            List {
                CountdownView(viewModel: viewModel)
                    .environmentObject(themeManager)
                    .listRowSeparator(.hidden)
                    .padding(.horizontal, -16)
                    .buttonStyle(.plain)

                NextLaunchView(
                    viewModel: viewModel,
                    selected: $selected,
                    preferredCompactColumn: $preferredColumn
                )
                .environmentObject(themeManager)
                .listRowSeparator(.hidden)
                .padding(.horizontal, -16)
                .buttonStyle(.plain)

                PreviousLaunchesView(viewModel: viewModel)
                    .environmentObject(themeManager)
                    .listRowSeparator(.hidden)
                    .padding(.horizontal, -16)
                    .buttonStyle(.plain)
            }
            .listStyle(.inset)
            .navigationTitle("Launches")
        } detail: {
            ZStack {
                if let id = selected {
                    LaunchDetailsView(launchId: id)
                } else {
                    ContentUnavailableView("Select a launch", image: "rocket-template")
                }
            }
        }
    }
}

#Preview {
    LaunchesView()
        .environmentObject(ThemeManager())
}
