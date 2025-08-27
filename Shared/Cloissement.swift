import SwiftUI

struct CloisonnementView: View {
    @State private var longueurMur: String = ""
    @State private var hauteurMur: String = ""
    @State private var typePlaque: String = "BA13 Standard"
    @State private var typeOssature: String = "48 mm"
    @State private var doubleMontant: Bool = false
    @State private var includePorte: Bool = false
    @State private var resultats: String = ""

    let typesPlaque = ["BA13 Standard", "BA13 Hydrofuge", "BA15 Feu"]
    let typesOssature = ["48 mm", "70 mm", "100 mm"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("CLOISSONNEMENT")
                    .font(.title)
                    .bold()
                
                TextField("Hauteur du mur (m)", text: $hauteurMur)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Longueur du mur (m)", text: $longueurMur)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Picker("Type de plaque", selection: $typePlaque) {
                    ForEach(typesPlaque, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                Picker("Ossature (montants / rails)", selection: $typeOssature) {
                    ForEach(typesOssature, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                Toggle("Montants doublés (renfort)", isOn: $doubleMontant)
                Toggle("Inclure une porte (optionnel)", isOn: $includePorte)

                Button("CALCULER") {
                    calculerCloisonnement()
                }
                  .buttonStyle(.borderedProminent)
                  .tint(.blue)
                  .controlSize(.large)

                if !resultats.isEmpty {
                    Text(resultats)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(10)
                        .font(.system(.body, design: .monospaced))
                }
            }
            .padding()
            
        }
    }

    func calculerCloisonnement() {
        guard let longueur = Double(longueurMur.replacingOccurrences(of: ",", with: ".")),
              let hauteur = Double(hauteurMur.replacingOccurrences(of: ",", with: ".")) else {
            resultats = "⚠️ Vérifie tes saisies."
            return
        }

        let surfaceMur = longueur * hauteur
        let surfaceNette = includePorte ? surfaceMur - 2.0 : surfaceMur

        let plaques = Int(ceil(surfaceNette / 3.0))
        let entraxeMontants = 0.6
        let nbMontants = Int((longueur / entraxeMontants).rounded(.up)) + 1
        let totalMontants = doubleMontant ? nbMontants * 2 : nbMontants

        let nbRails = 2 // haut et bas
        let longueurRails = longueur * Double(nbRails)
        let rails3m = Int(ceil(longueurRails / 3.0))

        let vis = plaques * 50
        let bandes = surfaceMur

        resultats = """
📐 Surface murale : \(String(format: "%.2f", surfaceMur)) m²
🧱 Surface nette (hors porte) : \(String(format: "%.2f", surfaceNette)) m²

📦 Plaques de plâtre (\(typePlaque)) : \(plaques)
🪚 Montants métalliques (\(typeOssature)) : \(totalMontants)
📏 Rails (haut/bas) 3 m : \(rails3m)
🩹 Bandes à joint : \(String(format: "%.1f", bandes)) ml
🔩 Vis : \(vis)
"""
    }
}

