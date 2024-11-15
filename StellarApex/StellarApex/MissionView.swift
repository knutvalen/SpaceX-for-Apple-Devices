import CachedAsyncImage
import SwiftUI

struct MissionView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var viewModel: LaunchViewModel

    var body: some View {
        if let mission = viewModel.nextLaunch?.mission,
           let program = viewModel.nextLaunch?.rocket?.configuration?.programs?.first ?? viewModel.nextLaunch?.programs?.first
        {
            VStack(alignment: .leading) {
                if let imageURL = mission.image?.url ?? program.image?.url {
                    CachedAsyncImage(url: URL(string: imageURL)) { phase in
                        switch phase {
                        case let .success(image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)

                        case .failure:
                            EmptyView()

                        case .empty:
                            ProgressView()
                                .controlSize(.small)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)

                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                if let name = mission.name {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(name)
                            .font(.title)

                        if let description = mission.description {
                            Text(description)
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        if let type = mission.type {
                            Divider()

                            Text("Mission Type")
                                .font(.headline)

                            Text(type)
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        if let orbit = mission.orbit?.name {
                            Divider()

                            Text("Orbit")
                                .font(.headline)

                            Text(orbit)
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        if let patches = viewModel.nextLaunch?.patches, patches.count > 0 {
                            Divider()

                            Text(patches.count == 1 ? "Patch" : "Patches")
                                .font(.headline)

                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(patches) {
                                        if let patchImage = $0.imageURL {
                                            CachedAsyncImage(url: URL(string: patchImage)) { phase in
                                                switch phase {
                                                case let .success(image):
                                                    image.resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 120, height: 120)

                                                case .failure:
                                                    EmptyView()

                                                case .empty:
                                                    ProgressView()
                                                        .controlSize(.small)
                                                        .frame(width: 120, height: 120)

                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        } else {
                                            EmptyView()
                                        }
                                    }
                                }
                            }
                        }

                        if let programName = program.name {
                            Text("Program")
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 16) {
                                Text("Name")
                                    .font(.headline)

                                Text(programName)
                                    .font(.none)
                                    .fixedSize(horizontal: false, vertical: true)

                                if let description = program.description {
                                    Divider()

                                    Text("Description")
                                        .font(.headline)

                                    Text(description)
                                        .font(.none)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                if let type = program.type?.name {
                                    Divider()

                                    Text("Program Type")
                                        .font(.headline)

                                    Text(type)
                                        .font(.none)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                if let agencies = program.agencies {
                                    Divider()

                                    Text(agencies.count == 1 ? "Agency" : "Agencies")
                                        .font(.headline)

                                    Text(agencies.map(\.name).joined(separator: ", "))
                                        .font(.none)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                if let startDate = program.startDate?.toStellarApexDateString() {
                                    Divider()

                                    Text("Start Date")
                                        .font(.headline)

                                    Text(startDate)
                                        .font(.none)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                if let endDate = program.endDate?.toStellarApexDateString() {
                                    Divider()

                                    Text("End Date")
                                        .font(.headline)

                                    Text(endDate)
                                        .font(.none)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            .padding(.horizontal)

                            Divider()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .background(themeManager.selectedTheme.cardColor)
            .cornerRadius(4)
            .shadow(color: themeManager.selectedTheme.shadowColor, radius: 2, x: 1, y: 2)
        } else {
            HStack {
                Spacer()
                ProgressView().onAppear {
                    Task {
                        await viewModel.getNextLaunch(ignoreCache: false)
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    MissionView(viewModel: LaunchViewModel())
        .environmentObject(ThemeManager())
}
