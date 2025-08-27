import SwiftUI
struct AccueilModulesView: View {
    let modules: [(
        title: String,
        icon: String,
        color: Color,
        destination: AnyView
    )] = [
        ("Aménagement intérieur", "house.fill", .blue, AnyView(AmenagementInterieurView())),
        ("Aménagement extérieur", "leaf.fill", .green, AnyView(AmenagementExterieurView())),
        ("Cloisonnement", "square.split.2x1.fill", .orange, AnyView(ModuleCloisonnementView()))
        // 👉 You can add more here easily later
    ]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())] // 2 per row
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Bienvenue sur EasyBat")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(modules, id: \.title) { module in
                        ModuleCard(
                            title: module.title,
                            icon: module.icon,
                            color: module.color,
                            destination: module.destination
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationTitle("EasyBat")
    }
}
