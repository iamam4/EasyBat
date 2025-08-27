import SwiftUI

struct AmenagementExterieurView: View {
    var body: some View {
            List {
                Section(header: Text("Modules Extérieurs")
                    .font(.caption)
                    .foregroundColor(.secondary)) {
                    
                    NavigationLink(destination: CalculBetonView()) {
                        Label("Dalle Béton", systemImage: "cube.box.fill")
                    }

                    NavigationLink(destination: CalculPilierView()) {
                        Label("Pilier Béton", systemImage: "rectangle.stack.fill")
                    }

                    NavigationLink(destination: CalculRagreageView()) {
                        Label("Ragréage", systemImage: "waveform.path.ecg")
                    }

                    NavigationLink(destination: CalculMortierView()) {
                        Label("Chape Mortier", systemImage: "scalemass")
                    }

                    NavigationLink(destination: CalculCharpenteView()) {
                        Label("Charpente / Toiture", systemImage: "house.lodge")
                    }

                    NavigationLink(destination: ParpaingView()) {
                        Label("Parpaing", systemImage: "square.grid.3x2.fill")
                    }

                    NavigationLink(destination: ModuleTerrasseView()) {
                        Label("Terrasse", systemImage: "sun.max.fill")
                    }

                    NavigationLink(destination: CalculAlleeView()) {
                        Label("Allée", systemImage: "figure.walk")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Aménagement Extérieur")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

