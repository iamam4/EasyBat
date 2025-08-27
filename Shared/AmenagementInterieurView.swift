import SwiftUI

struct AmenagementInterieurView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Modules Intérieurs")
                    .font(.headline)
                    .foregroundColor(.primary)) {
                    
                    NavigationLink(destination: CalculPlacoDoublageView()) {
                        Label("Placo (Doublage)", systemImage: "rectangle.3.offgrid.fill")
                    }
                    
                    NavigationLink(destination: ModuleCloisonnementView()) {
                        Label("Cloisonnement", systemImage: "square.split.2x1.fill")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Aménagement Intérieur")
        }
    }
}

struct AmenagementInterieurView_Previews: PreviewProvider {
    static var previews: some View {
        AmenagementInterieurView()
            .preferredColorScheme(.dark)
    }
}

