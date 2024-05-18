//
//  CustomButtonModifier.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 06/05/2024.
//

import SwiftUI

struct CustomButtonModifier: ViewModifier {
    let fillColor: Color
    let borderWidth: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .containerRelativeFrame(.horizontal) { size, axis in
                size * 0.85
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(fillColor)
                    .strokeBorder(.blue, lineWidth: borderWidth)
            )
    }
}

extension View {
    func customButton(fillColor: Color, borderWidth: CGFloat) -> some View {
        modifier(CustomButtonModifier(fillColor: fillColor, borderWidth: borderWidth))
    }
}

