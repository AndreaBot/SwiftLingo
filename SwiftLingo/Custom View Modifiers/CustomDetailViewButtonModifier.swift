//
//  CustomDetailViewButtonModifier.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 17/05/2024.
//

import SwiftUI

struct CustomDetailViewButtonModifier: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundStyle(.background)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

extension View {
    func detailViewButton(color: Color) -> some View {
        modifier(CustomDetailViewButtonModifier(color: color))
    }
 }
