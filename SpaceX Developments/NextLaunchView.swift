//
//  NextLaunchView.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 29/09/2024.
//

import SwiftUI

struct NextLaunchView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var viewModel: NextLaunchViewModel
    @State private var path = NavigationPath()

    enum NavigationDestination {
        case details
    }

    var body: some View {
        NavigationStack(path: $path) {
            HStack {
                if let launch = viewModel.nextLaunch {
                    VStack(spacing: 24) {
                        HStack {
                            Text("Next launch")
                                .font(.title2)

                            Spacer()

                            Button {
                                path.append(NavigationDestination.details)
                            } label: {
                                Text("Details")
                            }
                            .buttonStyle(.borderedProminent)
                            .navigationDestination(for: NavigationDestination.self) { view in
                                if view == .details {
                                    LaunchDetailsView(launchId: launch.id)
                                }
                            }
                        }

                        HStack {
                            Text("Name")
                            Spacer()
                            Text(launch.name)
                        }

                        if let launchDate = launch.net.toLaunch(precision: launch.netPrecision) {
                            HStack {
                                Text("Launch date")
                                Spacer()
                                Text(launchDate)
                            }
                        }

                        if let webcast = launch.webcast,
                           let url = URL(string: webcast.url)
                        {
                            HStack {
                                Text("Webcast")
                                Spacer()
                                Image(systemName: "arrow.up.forward.app")
                                Link(webcast.type.name, destination: url)
                                    .buttonStyle(.borderless)
                            }
                        }
                    }
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            .padding(16)
            .background(themeManager.selectedTheme.cardColor)
            .cornerRadius(12)
            .shadow(color: themeManager.selectedTheme.shadowColor, radius: 2, x: 1, y: 2)
        }
    }
}

#Preview {
    NextLaunchView(viewModel: .init())
        .environmentObject(ThemeManager())
}
