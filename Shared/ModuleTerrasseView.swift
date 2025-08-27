import SwiftUI

struct ModuleTerrasseView: View {
    enum TypeLame: String, CaseIterable, Identifiable {
        case standard = "Lame standard"
        case personnalisee = "Lame personnalisée"
        var id: String { rawValue }
    }

    enum TypeSol: String, CaseIterable, Identifiable {
        case beton = "Sol béton"
        case nonBeton = "Sol non béton (plots à couler)"
        var id: String { rawValue }
    }

    @State private var typeLame: TypeLame = .standard
    @State private var typeSol: TypeSol = .beton

    @State private var longueurTerrasse: String = ""
    @State private var largeurTerrasse: String = ""

    @State private var longueurLame: String = "2.40"
    @State private var largeurLame: String = "0.14"
    @State private var entraxeLambourde: String = "0.40"
    @State private var jeuEntreLames: String = "0.005"

    @State private var nbLames: Double?
    @State private var nbLambourdes: Double?
    @State private var nbVis: Int?
    @State private var nbClips: Int?
    @State private var nbPlots: Int?

    var body: some View {
        Form {
            Section(header: Text("Type de lame")) {
                Picker("Type", selection: $typeLame) {
                    ForEach(TypeLame.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }.pickerStyle(.segmented)
            }

            if typeLame == .personnalisee {
                Section(header: Text("Dimensions d'une lame (en mètres)")) {
                    TextField("Longueur lame", text: $longueurLame)
                        .keyboardType(.decimalPad)
                    TextField("Largeur lame", text: $largeurLame)
                        .keyboardType(.decimalPad)
                }
            }

            Section(header: Text("Dimensions de la terrasse (en mètres)")) {
                TextField("Longueur", text: $longueurTerrasse)
                    .keyboardType(.decimalPad)
                TextField("Largeur", text: $largeurTerrasse)
                    .keyboardType(.decimalPad)
            }

            Section(header: Text("Configuration")) {
                TextField("Entraxe entre lambourdes (m)", text: $entraxeLambourde)
                    .keyboardType(.decimalPad)
                TextField("Jeu entre lames (m)", text: $jeuEntreLames)
                    .keyboardType(.decimalPad)
                Picker("Type de sol", selection: $typeSol) {
                    ForEach(TypeSol.allCases) { sol in
                        Text(sol.rawValue).tag(sol)
                    }
                }
            }

            Section {
                Button("Calculer") {
                    calculerTerrasse()
                }
            }

            if let nbLames, let nbLambourdes, let nbVis, let nbClips, let nbPlots {
                Section(header: Text("Résultats")) {
                    Text("Nombre de lames: \(nbLames, specifier: "%.1f")")
                    Text("Nombre de lambourdes: \(nbLambourdes, specifier: "%.1f")")
                    Text("Nombre de clips: \(nbClips)")
                    Text("Nombre de vis: \(nbVis)")
                    Text("Nombre de plots: \(nbPlots)")
                }
            }
        }
        .navigationTitle("Terrasse bois")
        .onChange(of: typeLame) { newValue in
            if newValue == .standard {
                longueurLame = "2.40"
                largeurLame = "0.14"
            }
        }
    }

    func calculerTerrasse() {
        guard
            let longT = Double(longueurTerrasse),
            let largT = Double(largeurTerrasse),
            let longLame = Double(longueurLame),
            let largLame = Double(largeurLame),
            let entraxe = Double(entraxeLambourde),
            let jeu = Double(jeuEntreLames)
        else {
            return
        }

        let surfaceTerrasse = longT * largT
        let surfaceLameUtile = longLame * (largLame + jeu)

        let nbLamesCalc = surfaceTerrasse / surfaceLameUtile
        let nbLambourdesCalc = ceil(largT / entraxe) + 1
        let nbClipsCalc = Int(nbLamesCalc * nbLambourdesCalc)
        let nbVisCalc = nbClipsCalc * 2

        let nbPlotsCalc: Int
        if typeSol == .beton {
            nbPlotsCalc = Int(nbLambourdesCalc) * 2 // plots à chaque extrémité
        } else {
            let espacementPlot = 0.70 // mètre entre plots pour terrasse bois
            nbPlotsCalc = Int((longT / espacementPlot).rounded(.up)) * Int(nbLambourdesCalc)
        }

        nbLames = nbLamesCalc
        nbLambourdes = nbLambourdesCalc
        nbClips = nbClipsCalc
        nbVis = nbVisCalc
        nbPlots = nbPlotsCalc
    }
}

