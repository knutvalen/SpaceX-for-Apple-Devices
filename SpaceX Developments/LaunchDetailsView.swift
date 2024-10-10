//
//  LaunchDetailsView.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 01/10/2024.
//

import SwiftUI

struct LaunchDetailsView: View {
    @StateObject private var viewModel = LaunchDetailsViewModel()
    @State var launchId: String?

    var body: some View {
        if let launch = viewModel.launchDetails,
           launch.id == launchId
        {
            if let patch = launch.patch {
                AsyncImage(url: URL(string: patch)) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 300, maxHeight: 300)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 300, maxHeight: 300)
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: 300, maxHeight: 300)
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            List {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(launch.name)
                }

                HStack {
                    Text("Status")
                    Spacer()
                    Text(launch.status.name)
                }

                if let launchDate = viewModel.getLaunchDate() {
                    HStack {
                        Text("Launch date")
                        Spacer()
                        Text(launchDate)
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Launch details")
        } else {
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }.onAppear {
                if let id = launchId {
                    viewModel.getLaunchDetails(for: id)
                }
            }
        }
    }
}

#Preview {
    LaunchDetailsView(launchId: "9d576892-dcf0-472b-92d1-37053ff549ab")
}
