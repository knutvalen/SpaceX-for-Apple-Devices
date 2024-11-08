import SwiftUI

struct NextLaunchView: View {
    init(
        tabSelection _: Binding<Selection>,
        launchId _: Binding<String?>,
        preferredColumn _: Binding<NavigationSplitViewColumn>
    ) {}

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    NextLaunchView(
        tabSelection: .constant(.nextLaunch),
        launchId: .constant(nil),
        preferredColumn: .constant(.sidebar)
    )
    .environmentObject(ThemeManager())
}
