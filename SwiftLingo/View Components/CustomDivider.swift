//
//  CustomDivider.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 18/05/2024.
//

import SwiftUI

struct CustomDivider: View {
    
    let height:CGFloat = 2
    
    var body: some View {
        RoundedRectangle(cornerRadius: height/2)
            .frame(height: height)
            .foregroundStyle(.blue)
    }
}

#Preview {
    CustomDivider()
}
