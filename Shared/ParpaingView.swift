import SwiftUI

struct ParpaingView: View {
    @State private var longueurMur: String = ""
    @State private var hauteurMur: String = ""
    @State private var typeParpaing: String = "20"
    @State private var affichageResultats: String = ""

    let typesParpaing = ["10", "15", "20"]

    var body: some View {
        Form {
            Section(header: Text("Dimensions du mur")) {
                TextField("Longueur (m)", text: $longueurMur)
                    .keyboardType(.decimalPad)
                TextField("Hauteur (m)", text: $hauteurMur)
                    .keyboardType(.decimalPad)
                Picker("Épaisseur parpaing (cm)", selection: $typeParpaing) {
                    ForEach(typesParpaing, id: \.self) { epaisseur in
                        Text("Parpaing creux \(epaisseur) cm")
                    }
                }
            }

            Button("Calculer") {
                calculerParpaings()
            }
            .foregroundColor(.blue)

            if !affichageResultats.isEmpty {
                Section(header: Text("Résultats")) {
                    Text(affichageResultats)
                        .font(.system(.body, design: .monospaced))
                }
            }
        }
        .navigationTitle("Parpaing")
    }

    func calculerParpaings() {
        guard let long = Double(longueurMur.replacingOccurrences(of: ",", with: ".")),
              let haut = Double(hauteurMur.replacingOccurrences(of: ",", with: ".")) else {
            affichageResultats = "Saisies invalides."
            return
        }

        let surfaceMur = long * haut // m²
        let nbParpaingsStandards = Int(ceil(surfaceMur * 10))

        // Parpaings d'angle automatiques : 1 poteau tous les 2m de long, hauteur 0.2m/parpaing
        let nbPoteaux = Int(long / 2.0) + 1
        let parpaingsParPoteau = Int(haut / 0.2)
        let nbAngles = nbPoteaux * parpaingsParPoteau

        // Parpaings horizontaux : 1 rangée = longueur / 0.5m
        let nbParpaingsHorizontaux = Int(long / 0.5)

        let totalParpaings = nbParpaingsStandards + nbAngles + nbParpaingsHorizontaux

        let volumeMortierM3 = surfaceMur * 0.03
        let sacsMortier30kg = Int(ceil(surfaceMur * 1.5))
        let bigBagsSable = volumeMortierM3 / 0.8
        let sacsCiment35kg = Int(ceil(volumeMortierM3 * 10))

        // Fondation : 40cm large × 25cm haut × longueur
        let volumeFondation = long * 0.4 * 0.25
        let bigBagsFondation = volumeFondation / 0.8
        let sacsCimentFondation = Int(ceil(volumeFondation * 10))

        affichageResultats = """
Surface du mur : \(String(format: "%.2f", surfaceMur)) m²

Parpaings standards : \(nbParpaingsStandards)
Parpaings d'angle : \(nbAngles)
Parpaings horizontaux : \(nbParpaingsHorizontaux)
➡️ Total parpaings : \(totalParpaings)

🔹 OPTION 1 – Mortier prêt à l’emploi :
Volume mortier : \(String(format: "%.2f", volumeMortierM3)) m³
Sacs mortier 30 kg : \(sacsMortier30kg)

🔹 OPTION 2 – Ciment + sable 0/4 :
Volume mortier : \(String(format: "%.2f", volumeMortierM3)) m³
Big bags sable 0/4 (0.8 m³) : \(String(format: "%.2f", bigBagsSable))
Sacs ciment 35 kg : \(sacsCiment35kg)

🔸 Fondation (semelle béton) :
Volume béton : \(String(format: "%.2f", volumeFondation)) m³
Big bags sable 0/16 (0.8 m³) : \(String(format: "%.2f", bigBagsFondation))
Sacs ciment 35 kg : \(sacsCimentFondation)
"""
    }
}

struct ParpaingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ParpaingView()
        }
    }
}
