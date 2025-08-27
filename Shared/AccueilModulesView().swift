import SwiftUI

struct AccueilModulesView: View {
    let modules: [(
        title: String,
        icon: String,
        color: Color,
        destination: AnyView
    )] = [
        ("Intérieur", "house.fill", .blue, AnyView(AmenagementInterieurView())),
        ("Isolation", "snowflake", .teal, AnyView(AmenagementExterieurView())),
        ("Extérieur", "leaf.fill", .green, AnyView(AmenagementExterieurView())),
        ("Fixations", "hammer.fill", .orange, AnyView(AmenagementExterieurView()))
        
    ]
    
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)

        
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Spacer()

                HStack(spacing: 16) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .padding(.top, -10)
                    
                    Text("EasyBat")
                        .font(.system(size: 46))
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.orange, .red.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottom
                            )
                        )
                }
                
                Text("Simplifiez la réalisation \n de vos devis avec EasyBat")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                LazyVGrid(columns: columns, spacing: 20) {
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
            }
        }
        
    }
}

