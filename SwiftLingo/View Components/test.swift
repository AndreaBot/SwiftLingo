//
//  test.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 18/05/2024.
//

import SwiftUI

struct test: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Button("Toggle") {
                isAnimating.toggle()
            }
            Image(systemName: "ellipsis")
                .font(.headline)
                .padding()
                .symbolEffect(.variableColor.iterative.hideInactiveLayers.nonReversing, options: isAnimating ? .repeating : .default, value: isAnimating)
                .transition(.opacity)
        }
    }
}

#Preview {
    test()
}
