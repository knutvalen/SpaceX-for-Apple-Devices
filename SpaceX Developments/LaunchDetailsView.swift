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
