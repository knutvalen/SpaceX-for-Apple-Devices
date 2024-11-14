import CachedAsyncImage
import SwiftUI

struct LaunchScrollView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var viewModel: LaunchViewModel

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                Group {
                    Circle()
                        .fill(Color.green)
                        .id(1)

                    Circle()
                        .fill(Color.blue)
                        .id(2)
                }
                .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.never)
    }
}

#Preview {
    LaunchScrollView(viewModel: LaunchViewModel())
        .environmentObject(ThemeManager())
}
