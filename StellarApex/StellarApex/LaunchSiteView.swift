import CachedAsyncImage
import CoreLocation
import MapKit
import SwiftUI

struct LaunchSiteView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var viewModel: LaunchViewModel

    var body: some View {
        if let takeoff = viewModel.nextLaunch?.pad {
            VStack(alignment: .leading) {
                if let imageURL = takeoff.location?.image?.url {
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

                if let name = takeoff.location?.name {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(name)
                            .font(.title)

                        if let description = takeoff.location?.description {
                            Text(description)
                                .font(.none)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        if let latitude = takeoff.location?.latitude,
                           let longitude = takeoff.location?.longitude
                        {
                            let region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(
                                    latitude: latitude,
                                    longitude: longitude
                                ),
                                span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
                            )

                            Map(position: .constant(.region(region))) {
                                Marker(name, coordinate: region.center)
                            }
                            .mapControls {
                                MapCompass()
                                #if os(iOS)
                                    MapScaleView()
                                #endif
                            }
                            .frame(height: 300)
                            .padding(.horizontal, -16)
                        }
                    }
                    .padding(.horizontal)
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
    LaunchSiteView(viewModel: LaunchViewModel())
        .environmentObject(ThemeManager())
}
