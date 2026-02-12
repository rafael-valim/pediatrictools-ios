import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    BallardScoreView()
                } label: {
                    Label {
                        VStack(alignment: .leading) {
                            Text("ballard_score_title")
                                .font(.headline)
                            Text("ballard_score_subtitle")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "calendar.badge.clock")
                            .foregroundStyle(.accent)
                            .font(.title2)
                    }
                }
            }
            .navigationTitle("app_title")
        }
    }
}

#Preview {
    HomeView()
}
