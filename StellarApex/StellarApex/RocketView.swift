import CachedAsyncImage
import MapKit
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

                if let name = configuration.fullName,
                   let description = configuration.description
                {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(name)
                            .font(.title)

                        Text(description)
                            .font(.none)
                            .fixedSize(horizontal: false, vertical: true)

                        if let manufacturer = configuration.manufacturer?.name {
                            Divider()

                            Text("Manufacturer")
                                .font(.headline)

                            Text(manufacturer)
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        if let countries = configuration.manufacturer?.countries {
                            Divider()

                            Text(countries.count == 1 ? "Country" : "Countries")
                                .font(.headline)

                            let names = countries.compactMap { $0.name }.joined(separator: ", ")

                            Text(names.description)
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        if let thrustAtLiftOff = configuration.thrustAtLiftOff {
                            Divider()

                            Text("Thrust at Liftoff")
                                .font(.headline)

                            Text("\(thrustAtLiftOff) Kilonewton")
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        if let diameter = configuration.diameter {
                            Divider()

                            Text("Diameter")
                                .font(.headline)

                            Text("\(diameter.formatted(.number.grouping(.automatic))) meters")
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        if let length = configuration.length {
                            Divider()

                            Text("Length")
                                .font(.headline)

                            Text("\(length.formatted(.number.grouping(.automatic))) meters")
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        if let launchCost = configuration.launchCost {
                            Divider()

                            Text("Launch Cost")
                                .font(.headline)

                            Text("$\(launchCost.formatted(.number.grouping(.automatic)))")
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        if let reusable = configuration.reusable {
                            Divider()

                            Text("Reusable")
                                .font(.headline)

                            Text(reusable ? "Yes" : "No")
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Divider()

                        if let launcherStage = launch.rocket?.launcherStage?.first,
                           let name = launcherStage.launcher?.serialNumber
                        {
                            Text("Launcher")
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 16) {
                                Text("Name")
                                    .font(.headline)

                                Text(name)
                                    .font(.none)
                                    .fixedSize(horizontal: false, vertical: true)

                                if let details = launcherStage.launcher?.details {
                                    Divider()

                                    Text("Description")
                                        .font(.headline)

                                    Text(details)
                                        .font(.none)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                if let landingSiteName = launcherStage.landing?.location?.name {
                                    Divider()

                                    Text("Landing Site")
                                        .font(.headline)

                                    Text(landingSiteName)
                                        .font(.none)
                                        .fixedSize(horizontal: false, vertical: true)

                                    if let latitude = launcherStage.landing?.location?.latitude,
                                       let longitude = launcherStage.landing?.location?.longitude
                                    {
                                        let region = MKCoordinateRegion(
                                            center: CLLocationCoordinate2D(
                                                latitude: latitude,
                                                longitude: longitude
                                            ),
                                            span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
                                        )

                                        Map(position: .constant(.region(region))) {
                                            Marker(landingSiteName, coordinate: region.center)
                                        }
                                        .mapControls {
                                            MapCompass()
                                            #if os(iOS)
                                                MapScaleView()
                                            #endif
                                        }
                                        .frame(height: 300)
                                        .padding(.horizontal, -32)
                                    }
                                }
                            }
                            .padding(.horizontal)

                            Divider()
                        }

                        if let spacecraftStage = launch.rocket?.spacecraftStage?.first,
                           let name = spacecraftStage.spacecraft?.name
                        {
                            Text("Spacecraft")
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 16) {
                                Text("Name")
                                    .font(.headline)

                                Text(name)
                                    .font(.none)
                                    .fixedSize(horizontal: false, vertical: true)

                                if let description = spacecraftStage.spacecraft?.description {
                                    Divider()

                                    Text("Description")
                                        .font(.headline)

                                    Text(description)
                                        .font(.none)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                if let landingSiteName = spacecraftStage.landing?.location?.name {
                                    Divider()

                                    Text("Landing Site")
                                        .font(.headline)

                                    Text(landingSiteName)
                                        .font(.none)
                                        .fixedSize(horizontal: false, vertical: true)

                                    if let latitude = spacecraftStage.landing?.location?.latitude,
                                       let longitude = spacecraftStage.landing?.location?.longitude
                                    {
                                        let region = MKCoordinateRegion(
                                            center: CLLocationCoordinate2D(
                                                latitude: latitude,
                                                longitude: longitude
                                            ),
                                            span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
                                        )

                                        Map(position: .constant(.region(region))) {
                                            Marker(landingSiteName, coordinate: region.center)
                                        }
                                        .mapControls {
                                            MapCompass()
                                            #if os(iOS)
                                                MapScaleView()
                                            #endif
                                        }
                                        .frame(height: 300)
                                        .padding(.horizontal, -32)
                                    }
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
    RocketView(viewModel: LaunchViewModel())
        .environmentObject(ThemeManager())
}
