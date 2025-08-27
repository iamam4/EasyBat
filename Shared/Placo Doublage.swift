import SwiftUI

struct CalculPlacoDoublageView: View {
    enum FormatPlaque: String, CaseIterable, Identifiable {
        case p2_5x0_6 = "2,5 × 0,60 m"
        case p2_5x1_2 = "2,5 × 1,20 m"
        case p3x1_2 = "3,0 × 1,20 m"

        var id: String { self.rawValue }

        var surface: Double {
            switch self {
            case .p2_5x0_6: return 1.5
            case .p2_5x1_2: return 3.0
            case .p3x1_2:   return 3.6
            }
        }
    }

    @State private var hauteur: String = ""
    @State private var longueur: String = ""
    @State private var nombreMurs: String = ""
    @State private var formatSelectionne: FormatPlaque = .p2_5x1_2

    @State private var surfaceTotale: Double?
    @State private var plaques: Int?
    @State private var rails: Int?
    @State private var montants: Int?
    @State private var doubleMontants: Int?
    @State private var boitesVis: Int?
    @State private var bandeJoint: Int?
    @State private var enduitJoint: Int?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("PLACO – DOUBLAGE")
                    .font(.title)
                    .bold()

                Group {
                    TextField("Hauteur (m)", text: $hauteur)
                        .onChange(of: hauteur) { _ in reset() }

                    TextField("Longueur (m)", text: $longueur)
                        .onChange(of: longueur) { _ in reset() }

                    TextField("Nombre de murs", text: $nombreMurs)
                        .onChange(of: nombreMurs) { _ in reset() }

                    Picker("Format des plaques", selection: $formatSelectionne) {
                        ForEach(FormatPlaque.allCases) { format in
                            Text(format.rawValue).tag(format)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.top, 10)
                }
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                
                Button("CALCULER") {
                    calculer()
                }
                  .buttonStyle(.borderedProminent)
                  .tint(.blue)
                  .controlSize(.large)

                if let surface = surfaceTotale,
                   let plaques = plaques,
                   let rails = rails,
                   let montants = montants,
                   let doubleMontants = doubleMontants,
                   let boites = boitesVis,
                   let bande = bandeJoint,
                   let enduit = enduitJoint {

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Surface totale :")
                            Spacer()
                            Text(String(format: "%.2f m²", surface))
                        }
                        HStack {
                            Text("Plaques \(formatSelectionne.rawValue) :")
                            Spacer()
                            Text("\(plaques)")
                        }
                        HStack {
                            Text("Rails horizontaux :")
                            Spacer()
                            Text("\(rails) ml")
                        }
                        HStack {
                            Text("Montants verticaux :")
                            Spacer()
                            Text("\(montants) pièces")
                        }
                        HStack {
                            Text("Double montant :")
                            Spacer()
                            Text("\(doubleMontants) pièces")
                        }
                        HStack {
                            Text("Boîtes de vis (1000) :")
                            Spacer()
                            Text("\(boites)")
                        }
                        HStack {
                            Text("Bande à joint :")
                            Spacer()
                            Text("\(bande) m")
                        }
                        HStack {
                            Text("Enduit à joint :")
                            Spacer()
                            Text("\(enduit) kg")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }

                Spacer()
            }
            .padding()
        }
    }

    func reset() {
        surfaceTotale = nil
        plaques = nil
        rails = nil
        montants = nil
        doubleMontants = nil
        boitesVis = nil
        bandeJoint = nil
        enduitJoint = nil
    }

    func calculer() {
        guard let h = Double(hauteur.replacingOccurrences(of: ",", with: ".")),
              let L = Double(longueur.replacingOccurrences(of: ",", with: ".")),
              let n = Double(nombreMurs.replacingOccurrences(of: ",", with: ".")) else {
            return
        }

        let surface = h * L * n
        let surfaceParPlaque = formatSelectionne.surface
        let nbPlaques = Int(ceil((surface / surfaceParPlaque) * 1.1)) // marge 10%
        let nbRails = Int(ceil(L * 2 * n))
        let nbMontants = Int(ceil((L / 0.6) * n))
        let nbDoubleMontants = nbMontants * 2
        let totalVis = surface * 25
        let nbBoitesVis = Int(ceil(totalVis / 1000))
        let totalBande = nbPlaques * 3
        let totalEnduitJoint = Int(ceil(Double(totalBande) * 0.35))

        surfaceTotale = surface
        plaques = nbPlaques
        rails = nbRails
        montants = nbMontants
        doubleMontants = nbDoubleMontants
        boitesVis = nbBoitesVis
        bandeJoint = totalBande
        enduitJoint = totalEnduitJoint
    }
}

