import SwiftUI

struct CalculCharpenteView: View {
    @State private var typeToiture: String = "Double pente"
    @State private var longueurBatiment: String = ""
    @State private var largeurBatiment: String = ""
    @State private var penteToit: String = "30"
    @State private var entraxeChevron: String = "60"
    @State private var contreLiteaunage: Bool = true
    @State private var afficherAidePente: Bool = false

    @State private var surfaceToit: Double = 0
    @State private var longueurChevron: Double = 0
    @State private var nombreChevrons: Int = 0
    @State private var nbBarresChevron: Int = 0
    @State private var nbPlatinesChevron: Int = 0
    @State private var nbBarresLiteaux: Int = 0
    @State private var totalLiteaux: Double = 0
    @State private var nbMadriers: Int = 0
    @State private var nbBarresMadriers: Int = 0
    @State private var totalMadriers: Double = 0
    @State private var nbBarresContreLiteaux: Int = 0
    @State private var totalContreLiteaux: Double = 0
    @State private var afficherResultats = false
    @State private var nbSegmentsMadriers: Int = 0
    @State private var nbSegmentsChevrons: Int = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                GroupBox(label: Label("Configuration toiture", systemImage: "house.lodge")) {
                    VStack(alignment: .leading, spacing: 16) {
                        Picker("Type de toiture", selection: $typeToiture) {
                            Text("Monopente").tag("Monopente")
                            Text("Double pente").tag("Double pente")
                            Text("Toit plat").tag("Toit plat")
                        }
                        .pickerStyle(SegmentedPickerStyle())

                        Text("Ce choix influence la pente, la surface et les fixations")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }

                GroupBox(label: Label("Dimensions bâtiment", systemImage: "ruler")) {
                    VStack(spacing: 12) {
                        HStack(spacing: 16) {
                            TextField("Longueur (m)", text: $longueurBatiment)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)

                            TextField("Largeur (m)", text: $largeurBatiment)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                        }

                        HStack(spacing: 16) {
                            TextField("Pente (%)", text: $penteToit)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)

                            Button("Aide pente") {
                                afficherAidePente.toggle()
                            }
                            .font(.footnote)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(6)
                        }

                        VStack(alignment: .leading) {
                            TextField("Entraxe chevron (cm)", text: $entraxeChevron)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                            Text("Valeur par défaut : 60 cm")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        Toggle("Contre-liteaunage", isOn: $contreLiteaunage)
                    }
                }

                Button(action: calculerCharpente) {
                    Label("CALCULER", systemImage: "hammer.fill")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                if afficherResultats {
                    VStack(alignment: .leading, spacing: 16) {
                        Label("Résultats détaillés", systemImage: "wrench.and.screwdriver")
                            .font(.system(size: 20, weight: .bold))

                        GroupBox(label: Label("Toiture", systemImage: "square.dashed")) {
                            ResultItem(label: "Surface", value: "\(String(format: "%.2f", surfaceToit)) m²", icon: "square.dashed")
                        }

                        GroupBox(label: Label("Chevrons", systemImage: "ruler")) {
    ResultItem(label: "Longueur utile", value: "\(String(format: "%.2f", longueurChevron)) m", icon: "arrow.left.and.right")
    ResultItem(label: "Tronçons", value: "1 × \(nombreChevrons) = \(nbBarresChevron) pièces de 3 m", icon: "ruler")
    ResultItem(label: "Platines", value: "\(nbPlatinesChevron)", icon: "bolt")
}

                        GroupBox(label: Label("Liteaux", systemImage: "line.3.horizontal")) {
                            ResultItem(label: "Barres", value: "\(nbBarresLiteaux) × 4 m", icon: "line.3.horizontal")
                            ResultItem(label: "Longueur totale", value: "\(String(format: "%.2f", totalLiteaux)) ml", icon: "arrow.down")
                        }

                        GroupBox(label: Label("Madriers", systemImage: "square.split.2x1")) {
    ResultItem(label: "Tronçons", value: "\(nbSegmentsMadriers) × \(nbMadriers) = \(nbBarresMadriers) pièces de 5 m", icon: "square.split.2x1")
    ResultItem(label: "Longueur totale", value: "\(String(format: "%.2f", totalMadriers)) ml", icon: "arrow.down.right")
}

                        if contreLiteaunage {
                            GroupBox(label: Label("Contre-liteaux", systemImage: "arrow.up.and.down")) {
    ResultItem(label: "Tronçons", value: "\(nbSegmentsChevrons) × \(nombreChevrons) = \(nbBarresContreLiteaux) pièces de 3 m", icon: "arrow.up.and.down")
    ResultItem(label: "Longueur totale", value: "\(String(format: "%.2f", totalContreLiteaux)) ml", icon: "arrow.triangle.branch")
}
                        }

                        GroupBox(label: Label("Supports", systemImage: "externaldrive.connected.to.line.below")) {
                            ResultItem(label: "Étriers madriers", value: "\(nbMadriers)", icon: "bricks")
                            ResultItem(label: "Sabots chevrons", value: "\(nombreChevrons)", icon: "hammer")
                            ResultItem(label: "Platines de jonction", value: "\(nbPlatinesChevron + (nbMadriers > 1 ? nbMadriers - 1 : 0))", icon: "link")
                        }

                        GroupBox(label: Label("Fixations", systemImage: "screwdriver")) {
                            ResultItem(label: "Vis ⌀6×120 mm (chevrons)", value: "\(nombreChevrons * 4)", icon: "wrench")
                            ResultItem(label: "Vis ⌀5×80 mm (liteaux)", value: "\(Int(surfaceToit * 2))", icon: "screwdriver")
                            if contreLiteaunage {
                                ResultItem(label: "Vis ⌀5×100 mm (contre-liteaux)", value: "\(nombreChevrons * 2)", icon: "arrow.triangle.branch")
                            }
                            ResultItem(label: "Vis ⌀8×160 mm (madriers)", value: "\(nbMadriers * 4)", icon: "wrench.and.screwdriver")
                        }

                        Text("🛠️ Assemblage :")
                            .font(.headline)
                        Text("Les pièces dépassant les longueurs commerciales sont automatiquement découpées. Prévoyez des platines aux jonctions (chevrons et madriers).")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Charpente")
        .preferredColorScheme(.dark)
        .alert(isPresented: $afficherAidePente) {
            Alert(
                title: Text("Aide pour la pente"),
                message: Text("""
La pente dépend du type de couverture :
• Bac acier : 5 % à 10 %
• Tuiles mécaniques : ≥ 30 %
• Tuiles plates : ≥ 40 %
• Zones neigeuses : prévoir +10 %

Exemple standard : 30 % pour une toiture classique.
"""),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    func calculerCharpente() {
        guard let long = Double(longueurBatiment),
              let larg = Double(largeurBatiment),
              let pente = Double(penteToit),
              let entraxe = Double(entraxeChevron) else {
            afficherResultats = false
            return
        }

        let largeurToit = (typeToiture == "Double pente") ? larg / 2 : larg
        surfaceToit = long * larg
        let hauteur = largeurToit * pente / 100
        longueurChevron = sqrt(pow(largeurToit, 2) + pow(hauteur, 2))

        let longueursDisponibles = [3.0, 4.0, 5.0, 6.0]
        let lgPieceChevron = longueursDisponibles.first(where: { $0 >= longueurChevron }) ?? 6.0

        nombreChevrons = Int((long * 100) / entraxe) + 1
        let nbSegmentsChevrons = Int(ceil(longueurChevron / lgPieceChevron))
        nbBarresChevron = nombreChevrons * nbSegmentsChevrons
        nbPlatinesChevron = nombreChevrons * (nbSegmentsChevrons - 1)

        totalLiteaux = surfaceToit
        let lgPieceLiteau = 4.0
        nbBarresLiteaux = Int(ceil(totalLiteaux / lgPieceLiteau))

        nbMadriers = Int(ceil(larg / 2.0))
        let lgPieceMadrier = longueursDisponibles.first(where: { $0 >= long }) ?? 6.0
        let nbSegmentsMadriers = Int(ceil(long / lgPieceMadrier))
        nbBarresMadriers = nbMadriers * nbSegmentsMadriers
        totalMadriers = Double(nbBarresMadriers) * lgPieceMadrier

        if contreLiteaunage {
            let nbContreLiteaux = nombreChevrons
            nbBarresContreLiteaux = nbContreLiteaux * nbSegmentsChevrons
            totalContreLiteaux = Double(nbContreLiteaux) * longueurChevron
        } else {
            nbBarresContreLiteaux = 0
            totalContreLiteaux = 0
        }

        afficherResultats = true
    }
}

struct ResultItem: View {
    var label: String
    var value: String
    var icon: String

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

