import SwiftUI

struct LaunchDetailsView: View {
    @StateObject private var viewModel = LaunchDetailsViewModel()
    @Binding var launchId: String

    private func minWidthClamp() -> CGFloat {
        let calc = UIScreen.main.bounds.width - 80

        if calc < 300 {
            return calc
        } else {
            return 300
        }
    }

    var body: some View {
        if let launch = viewModel.launchDetails,
           launch.id == launchId
        {
            List {
                if let patch = launch.patch {
                    HStack {
                        Spacer()

                        AsyncImage(url: URL(string: patch)) { phase in
                            switch phase {
                            case let .success(image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: minWidthClamp(), height: minWidthClamp())
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: minWidthClamp(), height: minWidthClamp())
                            case .empty:
                                ProgressView()
                                    .controlSize(.regular)
                                    .frame(width: minWidthClamp(), height: minWidthClamp())
                            @unknown default:
                                EmptyView()
                            }
                        }

                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                }

                HStack(alignment: .top) {
                    Text("Name")
                    Spacer()
                    Text(launch.name)
                }

                HStack(alignment: .top) {
                    Text("Status")
                    Spacer()
                    Text(launch.status.name)
                }

                if let launchDate = launch.net.toLaunch(precision: launch.netPrecision) {
                    HStack(alignment: .top) {
                        Text("Launch date")
                        Spacer()
                        Text(launchDate)
                    }

                    HStack(alignment: .top) {
                        Text("Launch date precision")
                        Spacer()
                        Text(launch.netPrecision.rawValue)
                    }
                }

                HStack(alignment: .top) {
                    Text("Webcasts")
                    Spacer()

                    if launch.webcasts.isEmpty {
                        Text("No webcasts available")
                    } else {
                        VStack(spacing: 16) {
                            ForEach(launch.webcasts) { webcast in
                                if let url = URL(string: webcast.url) {
                                    HStack(alignment: .top) {
                                        Spacer()
                                        Image(systemName: "arrow.up.forward.app")
                                        Link(webcast.type.name, destination: url)
                                            .buttonStyle(.borderless)
                                    }
                                }
                            }
                        }
                    }
                }

                HStack(alignment: .top) {
                    Text("Mission name")
                    Spacer()
                    Text(launch.mission.name)
                }

                HStack(alignment: .top) {
                    Text("Mission type")
                    Spacer()
                    Text(launch.mission.type)
                }

                if let missionDescription = launch.mission.description {
                    HStack(alignment: .top) {
                        Text("Mission description")
                        Spacer()
                        Text(missionDescription)
                    }
                }

                HStack(alignment: .top) {
                    Text("Orbit")
                    Spacer()
                    Text(launch.mission.orbit)
                }

                HStack(alignment: .top) {
                    Text("Details updated")
                    Spacer()
                    Text(
                        Date.RelativeFormatStyle(
                            presentation: .named,
                            capitalizationContext: .beginningOfSentence
                        )
                        .format(launch.lastUpdated)
                    )
                }
            }
            .listStyle(.inset)
            .navigationTitle("Launch details")
            .refreshable {
                viewModel.getLaunchDetails(for: launchId, ignoreCache: true)
            }
        } else {
            VStack {
                Spacer()

                ProgressView()
                    .controlSize(.large)

                Spacer()
            }.onChange(of: launchId, initial: true) {
                viewModel.getLaunchDetails(for: launchId, ignoreCache: false)
            }
        }
    }
}

#Preview {
    LaunchDetailsView(launchId: .constant("9d576892-dcf0-472b-92d1-37053ff549ab"))
}
