//
//  NextLaunchView.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 29/09/2024.
//

import SwiftUI

struct NextLaunchView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject private var viewModel = NextLaunchViewModel()

    var body: some View {
        HStack {
            if let nextLaunch = viewModel.nextLaunch {
                VStack(spacing: 24) {
                    HStack {
                        Text("Next launch")
                            .font(.title2)

                        Spacer()

                        NavigationLink {
                            LaunchDetailsView()
                                .environmentObject(
                                    LaunchDetailsViewModel(launchId: nextLaunch.id)
                                )
                        } label: {
                            Text("DETAILS")
                        }
                    }

                    HStack {
                        Text("Name")

                        Spacer()

                        Text(nextLaunch.name)
                    }

                    if let launchDate = viewModel.getLaunchDate() {
                        HStack {
                            Text("Launch date")

                            Spacer()

                            Text(launchDate)
                        }
                    }

                    if let webcast = viewModel.nextLaunch?.webcast,
                       let url = URL(string: webcast.url)
                    {
                        HStack {
                            Text("Webcast")

                            Spacer()

                            Image(systemName: "arrow.up.forward.app")

                            Link(webcast.type.name, destination: url)
                        }
                    }
                }
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .padding()
        .background(themeManager.selectedTheme.cardColor)
        .cornerRadius(12)
        .shadow(color: themeManager.selectedTheme.shadowColor, radius: 2, x: 1, y: 2)
    }
}

#Preview {
    NextLaunchView()
        .environmentObject(ThemeManager())
}
