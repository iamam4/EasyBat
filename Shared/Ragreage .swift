import SwiftUI

struct CalculRagreageView: View {
    struct ProduitRagreage: Identifiable, Hashable {
        let id = UUID()
        let nom: String
        let rendement: Double
    }

    let produits: [ProduitRagreage] = [
        ProduitRagreage(nom: "Ragréage autolissant intérieur – réf. 89080451", rendement: 1.5),
        ProduitRagreage(nom: "Ragréage fibré PRB – réf. 66876173", rendement: 1.6),
        ProduitRagreage(nom: "Ragréage AXTON 3 à 10 mm – réf. 89865240", rendement: 1.5),
        ProduitRagreage(nom: "Ragréage extérieur PRB – réf. 62227011", rendement: 1.6)
    ]

    @State private var produitSelectionne: ProduitRagreage = ProduitRagreage(
        nom: "Ragréage autolissant intérieur – réf. 89080451", rendement: 1.5
    )

    @State private var longueur: String = ""
    @State private var largeur: String = ""
    @State private var epaisseur: String = ""

    @State private var surface: Double?
    @State private var quantite: Double?
    @State private var sacs: Int?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("RAGRÉAGE")
                    .font(.title)
                    .bold()

                Picker("Produit", selection: $produitSelectionne) {
                    ForEach(produits) { produit in
                        Text(produit.nom).tag(produit)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)

                Group {
                    TextField("Longueur (m)", text: $longueur)
                        .onChange(of: longueur) { _ in reset() }

                    TextField("Largeur (m)", text: $largeur)
                        .onChange(of: largeur) { _ in reset() }

                    TextField("Épaisseur (mm)", text: $epaisseur)
                        .onChange(of: epaisseur) { _ in reset() }
                }
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

                Button("LANCER LE CALCUL") {
                    calculer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)

                if let surface = surface,
                   let quantite = quantite,
                   let sacs = sacs {

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Surface :")
                            Spacer()
                            Text(String(format: "%.2f m²", surface))
                        }
                        HStack {
                            Text("Quantité nécessaire :")
                            Spacer()
                            Text("\(formatEntier(Int(quantite))) kg")
                        }
                        HStack {
                            Text("Sacs de 25 kg :")
                            Spacer()
                            Text("\(sacs)")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }

                Spacer()
            }
            .padding()
        }
        .preferredColorScheme(.dark)
    }

    func reset() {
        surface = nil
        quantite = nil
        sacs = nil
    }

    func calculer() {
        guard let l = Double(longueur.replacingOccurrences(of: ",", with: ".")),
              let L = Double(largeur.replacingOccurrences(of: ",", with: ".")),
              let e = Double(epaisseur.replacingOccurrences(of: ",", with: ".")) else {
            return
        }

        let surfaceTotale = l * L
        let quantiteTotale = surfaceTotale * e * produitSelectionne.rendement
        let nbSacs = Int(ceil(quantiteTotale / 25))

        surface = surfaceTotale
        quantite = quantiteTotale
        sacs = nbSacs
    }

    func formatEntier(_ nombre: Int) -> String {
        return String(nombre)
    }
}

