//
//  SwiftLingoView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 05/05/2024.
//

import SwiftUI

struct SwiftLingoView: View {
    
    var body: some View {
        VStack(spacing: 20) {
            Image(.swiftLingoLogo)
                .resizable()
                .scaledToFit()
            
            Text("SwiftLingo")
                .font(.largeTitle).fontWeight(.heavy)
                .fontDesign(.rounded)
        }
        .containerRelativeFrame([.vertical]) { size, axis in
            size * 0.2
        }
    }
}

#Preview {
    SwiftLingoView()
}
