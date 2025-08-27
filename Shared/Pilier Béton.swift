import SwiftUI

struct CalculPilierView: View {
    @State private var longueur: String = ""
    @State private var largeur: String = ""
    @State private var hauteurPilier: String = ""
    @State private var hauteurPoteau: String = ""
    @State private var nombrePoteaux: String = ""
    @State private var dosage: String = "350"

    @State private var surfaceTotale: Double?
    @State private var volume: Double?
    @State private var cimentKg: Double?
    @State private var sacs: Int?
    @State private var sableKg: Double?
    @State private var gravierKg: Double?
    @State private var bigBags: Double?
    @State private var totalPiliers: Int?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("PILIER BÉTON")
                    .font(.title)
                    .bold()

                Group {
                    TextField("Longueur du pilier (cm)", text: $longueur)
                        .onChange(of: longueur) { _ in reset() }

                    TextField("Largeur du pilier (cm)", text: $largeur)
                        .onChange(of: largeur) { _ in reset() }

                    TextField("Hauteur d’un pilier (cm)", text: $hauteurPilier)
                        .onChange(of: hauteurPilier) { _ in reset() }

                    TextField("Hauteur totale du poteau (cm)", text: $hauteurPoteau)
                        .onChange(of: hauteurPoteau) { _ in reset() }

                    TextField("Nombre de poteaux", text: $nombrePoteaux)
                        .onChange(of: nombrePoteaux) { _ in reset() }

                    TextField("Dosage ciment (kg/m³)", text: $dosage)
                        .onChange(of: dosage) { _ in reset() }
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

                if let total = totalPiliers,
                   let surface = surfaceTotale,
                   let vol = volume,
                   let ciment = cimentKg,
                   let sacs = sacs,
                   let sable = sableKg,
                   let gravier = gravierKg,
                   let bigbags = bigBags {

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Nombre total de piliers :")
                            Spacer()
                            Text("\(total)")
                        }
                        HStack {
                            Text("Surface totale :")
                            Spacer()
                            Text(String(format: "%.2f m²", surface))
                        }
                        HStack {
                            Text("Volume total :")
                            Spacer()
                            Text(String(format: "%.2f m³", vol))
                        }
                        HStack {
                            Text("Ciment :")
                            Spacer()
                            Text("\(formatEntier(Int(ciment))) kg")
                        }
                        Text("(≈ \(sacs) sacs de 35kg)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        HStack {
                            Text("Sable :")
                            Spacer()
                            Text("\(formatEntier(Int(sable))) kg")
                        }
                        HStack {
                            Text("Gravier :")
                            Spacer()
                            Text("\(formatEntier(Int(gravier))) kg")
                        }
                        HStack {
                            Text("Big bags mélange 0,8 m³ :")
                            Spacer()
                            Text(String(format: "%.2f", bigbags))
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
        surfaceTotale = nil
        volume = nil
        cimentKg = nil
        sacs = nil
        sableKg = nil
        gravierKg = nil
        bigBags = nil
        totalPiliers = nil
    }

    func calculer() {
        guard let lCm = Double(longueur.replacingOccurrences(of: ",", with: ".")),
              let Lcm = Double(largeur.replacingOccurrences(of: ",", with: ".")),
              let hPilier = Double(hauteurPilier.replacingOccurrences(of: ",", with: ".")),
              let hPoteau = Double(hauteurPoteau.replacingOccurrences(of: ",", with: ".")),
              let nbPoteaux = Int(nombrePoteaux.replacingOccurrences(of: ",", with: ".")),
              let dosageCiment = Double(dosage.replacingOccurrences(of: ",", with: ".")) else {
            return
        }

        let nbPiliersParPoteau = Int(ceil(hPoteau / hPilier))
        let nbTotalPiliers = nbPiliersParPoteau * nbPoteaux

        let l = lCm / 100
        let L = Lcm / 100
        let h = hPilier / 100

        let surface = l * L * Double(nbTotalPiliers)
        let vol = l * L * h * Double(nbTotalPiliers)
        let ciment = vol * dosageCiment
        let sacsCiment = Int(ceil(ciment / 35.0))
        let sable = vol * 800
        let gravier = vol * 1100
        let melange = vol / 0.8

        surfaceTotale = surface
        volume = vol
        cimentKg = ciment
        sacs = sacsCiment
        sableKg = sable
        gravierKg = gravier
        bigBags = melange
        totalPiliers = nbTotalPiliers
    }

    func formatEntier(_ nombre: Int) -> String {
        return String(nombre)
    }
}

