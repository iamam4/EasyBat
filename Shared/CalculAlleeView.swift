import SwiftUI

struct CalculAlleeView: View {
    enum TypeRevêtement: String, CaseIterable, Identifiable {
        case pavee = "Allée pavée"
        case gravier = "Allée gravillonnée"
        var id: String { rawValue }
    }

    enum TypeCirculation: String, CaseIterable, Identifiable {
        case pieton = "Circulation piétonne"
        case vehicule = "Voiture / véhicule léger"
        var id: String { rawValue }
    }

    @State private var typeAllee: TypeRevêtement = .pavee
    @State private var typeCirculation: TypeCirculation = .pieton

    @State private var longueur: String = ""
    @State private var largeur: String = ""

    @State private var longueurPave: String = "20"
    @State private var largeurPave: String = "10"
    @State private var jointPave: String = "1"

    @State private var epaisseurSable: String = "4"
    @State private var epaisseurGravier: String = "10"

    @State private var borduresGauche: Bool = true
    @State private var borduresDroite: Bool = true

    @State private var surfaceTotale: Double?
    @State private var nbPaves: Int?
    @State private var volumeSable: Double?
    @State private var volumeGravier: Double?
    @State private var longueurBordures: Double?

    var body: some View {
        Form {
            Section(header: Text("Type d'allée")) {
                Picker("Revêtement", selection: $typeAllee) {
                    ForEach(TypeRevêtement.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }.pickerStyle(.segmented)

                Picker("Circulation", selection: $typeCirculation) {
                    ForEach(TypeCirculation.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }.pickerStyle(.segmented)
            }

            Section(header: Text("Dimensions de l'allée (en mètres)")) {
                TextField("Longueur", text: $longueur)
                    .keyboardType(.decimalPad)
                TextField("Largeur", text: $largeur)
                    .keyboardType(.decimalPad)
            }

            if typeAllee == .pavee {
                Section(header: Text("Dimensions des pavés (en cm)")) {
                    TextField("Longueur pavé", text: $longueurPave)
                        .keyboardType(.decimalPad)
                    TextField("Largeur pavé", text: $largeurPave)
                        .keyboardType(.decimalPad)
                    TextField("Joint entre pavés (cm)", text: $jointPave)
                        .keyboardType(.decimalPad)
                }
            }

            Section(header: Text("Épaisseurs des couches (en cm)")) {
                TextField("Lit de sable", text: $epaisseurSable)
                    .keyboardType(.decimalPad)
                TextField("Lit de gravier", text: $epaisseurGravier)
                    .keyboardType(.decimalPad)
            }

            Section(header: Text("Bordures")) {
                Toggle("Bordure à gauche", isOn: $borduresGauche)
                Toggle("Bordure à droite", isOn: $borduresDroite)
            }

            Section {
                Button("Calculer") {
                    adapterEpaisseursSelonCirculation()
                    calculer()
                }
            }

            if let surfaceTotale, let volumeSable, let volumeGravier {
                Section(header: Text("Résultats")) {
                    Text("Surface totale : \(surfaceTotale, specifier: "%.2f") m²")
                    if typeAllee == .pavee, let nbPaves {
                        Text("Nombre de pavés : \(nbPaves)")
                    }
                    Text("Volume sable : \(volumeSable, specifier: "%.2f") m³")
                    Text("Volume gravier : \(volumeGravier, specifier: "%.2f") m³")
                    if let longueurBordures {
                        Text("Longueur de bordures : \(longueurBordures, specifier: "%.2f") m")
                    }
                }
            }
        }
        .navigationTitle("Allée pavée / gravier")
    }

    func adapterEpaisseursSelonCirculation() {
        switch typeCirculation {
        case .pieton:
            epaisseurSable = "4"
            epaisseurGravier = "10"
        case .vehicule:
            epaisseurSable = "4"
            epaisseurGravier = "20"
        }
    }

    func calculer() {
        guard
            let long = Double(longueur),
            let larg = Double(largeur),
            let epSable = Double(epaisseurSable),
            let epGravier = Double(epaisseurGravier)
        else {
            return
        }

        let surface = long * larg
        let volumeSableCalc = surface * (epSable / 100)
        let volumeGravierCalc = surface * (epGravier / 100)

        surfaceTotale = surface
        volumeSable = volumeSableCalc
        volumeGravier = volumeGravierCalc

        if typeAllee == .pavee,
           let longPave = Double(longueurPave),
           let largPave = Double(largeurPave),
           let joint = Double(jointPave) {

            let longTotal = (longPave + joint) / 100
            let largTotal = (largPave + joint) / 100
            let surfaceUnitaire = longTotal * largTotal
            let nb = (surface / surfaceUnitaire * 1.05).rounded(.up) // +5% marge
            nbPaves = Int(nb)
        } else {
            nbPaves = nil
        }

        var bordures: Double = 0
        if borduresGauche { bordures += long }
        if borduresDroite { bordures += long }
        longueurBordures = bordures
    }
}

