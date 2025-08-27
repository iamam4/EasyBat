import SwiftUI

struct CalculMortierView: View {
    @State private var longueur: String = ""
    @State private var largeur: String = ""
    @State private var epaisseur: String = ""
    @State private var dosage: String = "350"

    @State private var surface: Double?
    @State private var volume: Double?
    @State private var cimentKg: Double?
    @State private var nombreSacs: Int?
    @State private var sableKg: Double?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("CHAPE / MORTIER")
                    .font(.title)
                    .bold()

                Group {
                    TextField("Longueur (m)", text: $longueur)
                        .onChange(of: longueur) { _ in reset() }

                    TextField("Largeur (m)", text: $largeur)
                        .onChange(of: largeur) { _ in reset() }

                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Épaisseur (cm)", text: $epaisseur)
                            .onChange(of: epaisseur) { _ in reset() }

                        Text("Ne pas dépasser 6 cm")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.leading, 5)
                    }

                    TextField("Dosage ciment (kg/m³)", text: $dosage)
                        .onChange(of: dosage) { _ in reset() }
                }
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

                Button(action: calculer) {
                    Text("LANCER LE CALCUL")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                if let surface = surface,
                   let v = volume,
                   let c = cimentKg,
                   let s = nombreSacs,
                   let sable = sableKg {

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Surface de chape :")
                            Spacer()
                            Text(String(format: "%.2f m²", surface))
                        }
                        HStack {
                            Text("Volume :")
                            Spacer()
                            Text(String(format: "%.2f m³", v))
                        }
                        HStack {
                            Text("Ciment :")
                            Spacer()
                            Text("\(formatEntier(Int(c))) kg")
                        }
                        Text("(≈ \(s) sacs de 35kg)")
                            .font(.caption)
                            .foregroundColor(.gray)

                        HStack {
                            Text("Sable :")
                            Spacer()
                            Text("\(formatEntier(Int(sable))) kg")
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
        volume = nil
        cimentKg = nil
        nombreSacs = nil
        sableKg = nil
    }

    func calculer() {
        guard let l = Double(longueur.replacingOccurrences(of: ",", with: ".")),
              let L = Double(largeur.replacingOccurrences(of: ",", with: ".")),
              let eCm = Double(epaisseur.replacingOccurrences(of: ",", with: ".")),
              let dosageCiment = Double(dosage.replacingOccurrences(of: ",", with: ".")) else {
            return
        }

        let e = eCm / 100
        let v = l * L * e
        let ciment = v * dosageCiment
        let sacs = Int(ceil(ciment / 35.0))
        let sable = v * 1200

        surface = l * L
        volume = v
        cimentKg = ciment
        nombreSacs = sacs
        sableKg = sable
    }

    func formatEntier(_ nombre: Int) -> String {
        return String(nombre)
    }
}

