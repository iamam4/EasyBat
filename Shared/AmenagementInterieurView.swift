import SwiftUI

struct AmenagementInterieurView: View {
    var body: some View {
        List {
            Section(header: Text("Modules Intérieurs")
                .font(.caption)
                .foregroundColor(.primary)) {

                NavigationLink(destination: CalculPlacoDoublageView()) {
                    Label("Placo (Doublage)", systemImage: "rectangle.3.offgrid.fill")
                }

                NavigationLink(destination: CloisonnementView()) {
                    Label("Cloisonnement", systemImage: "square.split.2x1.fill")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Aménagement Intérieur")
        .navigationBarTitleDisplayMode(.inline)
    }
}

