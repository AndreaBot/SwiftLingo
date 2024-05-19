//
//  ConfirmationMessageView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 17/05/2024.
//

import SwiftUI

struct ConfirmationMessageView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .padding()
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ConfirmationMessageView(message: "This is a test message")
}
