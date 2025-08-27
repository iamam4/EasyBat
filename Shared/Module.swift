import SwiftUI

struct Module: Identifiable, Hashable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let destination: AnyView

    static func == (lhs: Module, rhs: Module) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

