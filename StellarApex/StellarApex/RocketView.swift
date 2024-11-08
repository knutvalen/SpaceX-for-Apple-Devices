import CachedAsyncImage
import SwiftUI

struct RocketView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var viewModel: LaunchViewModel

    var body: some View {
        if let launch = viewModel.nextLaunch,
           let configuration = launch.rocket?.configuration
        {
            VStack(alignment: .leading) {
                if let url = configuration.image?.url {
                    CachedAsyncImage(url: URL(string: url)) { phase in
                        switch phase {
                        case let .success(image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .fixedSize(horizontal: false, vertical: true)

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

                VStack(alignment: .leading, spacing: 16) {
                    Text(configuration.name)
                        .font(.title)

                    if let description = configuration.description {
                        Text(description)
                            .font(.none)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if let thrustAtLiftOff = configuration.thrustAtLiftOff {
                        Text("Thrust at Liftoff")
                            .font(.headline)

                        Text("\(thrustAtLiftOff) Kilonewton")
                            .font(.none)
                            .fixedSize(horizontal: false, vertical: true)

                        Divider()
                    }

                    if let diameter = configuration.diameter {
                        Text("Diameter")
                            .font(.headline)

                        Text("\(diameter.formatted(.number.grouping(.automatic))) meters")
                            .font(.none)
                            .fixedSize(horizontal: false, vertical: true)

                        Divider()
                    }

                    if let length = configuration.length {
                        Text("Length")
                            .font(.headline)

                        Text("\(length.formatted(.number.grouping(.automatic))) meters")
                            .font(.none)
                            .fixedSize(horizontal: false, vertical: true)

                        Divider()
                    }

                    if let launchCost = configuration.launchCost {
                        Text("Launch Cost")
                            .font(.headline)

                        Text("\(launchCost.formatted(.number.grouping(.automatic))) $")
                            .font(.none)
                            .fixedSize(horizontal: false, vertical: true)

                        Divider()
                    }

                    if let launcher = launch.rocket?.launcherStage.first?.launcher {
                        Text("Launcher")
                            .font(.title2)

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Name")
                                .font(.headline)

                            Text(launcher.serialNumber)
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)

                            Divider()

                            Text("Description")
                                .font(.headline)

                            Text(launcher.details)
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal)

                        Divider()
                    }

                    if let spacecraft = launch.rocket?.spacecraftStage.first?.spacecraft {
                        Text("Spacecraft")
                            .font(.title2)

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Name")
                                .font(.headline)

                            Text(spacecraft.name)
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)

                            Divider()

                            Text("Description")
                                .font(.headline)

                            Text(spacecraft.description)
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(themeManager.selectedTheme.cardColor)
            .cornerRadius(4)
            .shadow(color: themeManager.selectedTheme.shadowColor, radius: 2, x: 1, y: 2)
        } else {
            ProgressView().onAppear {
                Task {
                    await viewModel.getNextLaunch(ignoreCache: false)
                }
            }
        }
    }
}

#Preview {
    RocketView(viewModel: LaunchViewModel())
        .environmentObject(ThemeManager())
}
