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
            VStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                    .frame(width: 60, height: 60)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

            }
            .frame(width: 90, height: 120)
            .padding(EdgeInsets(top: 20, leading: 45, bottom: 20, trailing: 45))
            .background(Color.gray.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            
        }
    }
}
