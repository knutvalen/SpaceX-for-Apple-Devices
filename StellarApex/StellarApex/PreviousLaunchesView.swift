import SwiftUI

struct PreviousLaunchesView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var viewModel: LaunchViewModel
    @Binding var launchId: String?
    @Binding var preferredColumn: NavigationSplitViewColumn

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Previous launches")
                    .font(.title2)

                Spacer()
            }

            if let launches = viewModel.previousLaunches {
                ForEach(launches) { launch in
                    VStack {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    Text("Name")
                                        .font(.headline)

                                    Text(launch.name)
                                        .font(.subheadline)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                Spacer()

                                #if !os(watchOS)
                                    Button {
                                        launchId = launch.id
                                        preferredColumn = .detail
                                    } label: {
                                        Image("rocket-template-tiny")
                                        Text("Details")
                                    }
                                    .buttonStyle(.borderedProminent)
                                #endif
                            }

                            if let launchDate = launch.net.toLaunch(precision: launch.netPrecision) {
                                VStack(alignment: .leading) {
                                    Text("Launch date")
                                        .font(.headline)

                                    Text(launchDate)
                                        .font(.subheadline)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }

                            #if os(watchOS)
                                Button {
                                    launchId = launch.id
                                    preferredColumn = .detail
                                } label: {
                                    Image("rocket-template-tiny")
                                    Text("Details")
                                }
                                .buttonStyle(.borderedProminent)
                            #endif
                        }
                        #if !os(watchOS)
                        .background(themeManager.selectedTheme.cardColor)
                        #endif
                    }
                    #if !os(watchOS)
                    .background(themeManager.selectedTheme.listDividerColor)
                    #endif

                    Divider()
                }
            } else {
                HStack {
                    Spacer()

                    ProgressView()
                        .controlSize(.regular)

                    Spacer()
                }
            }
        }
        #if !os(watchOS)
        .padding(16)
        .background(themeManager.selectedTheme.cardColor)
        .cornerRadius(12)
        .shadow(color: themeManager.selectedTheme.shadowColor, radius: 2, x: 1, y: 2)
        .frame(maxHeight: .infinity)
        #else
        .padding(8)
        #endif
    }
}

#Preview {
    PreviousLaunchesView(
        viewModel: LaunchViewModel(),
        launchId: .constant(nil),
        preferredColumn: .constant(NavigationSplitViewColumn.sidebar)
    )
    .environmentObject(ThemeManager())
}
