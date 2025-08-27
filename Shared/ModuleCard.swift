//
//  ModuleCard 2.swift
//  Le Batiment Dans la Poche
//
//  Created by Alexandre on 17/08/2025.
//


import SwiftUI

struct ModuleCard: View {
    let title: String
    let icon: String
    let color: Color
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                    .frame(width: 60, height: 60)
                    .background(color.opacity(0.2))
                    .clipShape(Circle())
                
                Text(title)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 160)
            .background(Color("CardBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
}
