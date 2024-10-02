//
//  LaunchDetailsView.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 01/10/2024.
//

import SwiftUI

struct LaunchDetailsView: View {
    @EnvironmentObject var viewModel: LaunchDetailsViewModel

    var body: some View {
        if let launchDetails = viewModel.launchDetails {
            VStack {
                Text(launchDetails.mission.name)
                    .font(.headline)
                    .padding()
            }
        } else {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

#Preview {
    let viewModel = LaunchDetailsViewModel(launchId: "123456")
    LaunchDetailsView().environmentObject(viewModel)
}
