import SwiftUI

struct NextLaunchView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var viewModel: LaunchViewModel
    @Binding var launchId: String?
    @Binding var preferredColumn: NavigationSplitViewColumn

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Next launch")
                    .font(.title2)

                Spacer()
                #if !os(watchOS)
                    if let launch = viewModel.nextLaunch {
                        Button {
                            launchId = launch.id
                            preferredColumn = .detail
                        } label: {
                            Image("rocket-tiny-template")
                            Text("Details")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                #endif
            }

            if let launch = viewModel.nextLaunch {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Name")
                                .font(.headline)

                            Text(launch.name)
                                .font(.subheadline)
                                .fixedSize(horizontal: false, vertical: true)
                        }
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
                        if let launch = viewModel.nextLaunch {
                            Button {
                                launchId = launch.id
                                preferredColumn = .detail
                            } label: {
                                Image("rocket-tiny-template")
                                Text("Details")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    #endif
                }
            } else {
                HStack {
                    Spacer()

                    ProgressView()
                        .controlSize(.large)

                    Spacer()
                }
            }
        }
        #if !os(watchOS)
        .padding(16)
        .background(themeManager.selectedTheme.cardColor)
        .cornerRadius(12)
        .shadow(color: themeManager.selectedTheme.shadowColor, radius: 2, x: 1, y: 2)
        #else
        .padding(8)
        #endif
    }
}

#Preview {
    NextLaunchView(
        viewModel: LaunchViewModel(),
        launchId: .constant(nil),
        preferredColumn: .constant(NavigationSplitViewColumn.sidebar)
    )
    .environmentObject(ThemeManager())
}
