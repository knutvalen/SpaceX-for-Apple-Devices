//
//  LaunchesView.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 27/09/2024.
//

import SwiftUI

struct LaunchesView: View {
    private var themeManager = ThemeManager()
    @ObservedObject private var viewModel = NextLaunchViewModel()

    var body: some View {
        NavigationSplitView {
            List {
                CountdownView(viewModel: viewModel)
                    .environmentObject(themeManager)
                    .listRowSeparator(.hidden)
                    .padding(.horizontal, -16)

                NextLaunchView(viewModel: viewModel)
                    .environmentObject(themeManager)
                    .listRowSeparator(.hidden)
                    .padding(.horizontal, -16)
                    .listRowSeparator(.hidden)
                    .background(
                        NavigationLink(destination: LaunchDetailsView(launchId: viewModel.nextLaunch?.id), label: {
                            EmptyView()
                        })
                        .opacity(0)
                    )
            }
            .listStyle(.inset)
            .navigationTitle("Launches")
        } detail: {
            ContentUnavailableView("Select a launch", image: "rocket-template")
        }
    }
}

#Preview {
    LaunchesView()
        .environmentObject(ThemeManager())
}
