import SwiftUI

@main
struct Le_Batiment_Dans_la_PocheApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView()
        }
    }
    
struct ContentView: View {
        var body: some View {
            NavigationStack {
                AccueilModulesView()
            }
        }
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
            
        }
    }
}



