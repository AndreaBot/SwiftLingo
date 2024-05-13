//
//  MenuView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 13/05/2024.
//

import SwiftUI

struct MenuView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var authViewModel: FirebaseAuthViewModel
    
    var body: some View {
        VStack {
            DismissToolbar(dismissAction: dismiss)
            Form {
                Button("Logout", action: authViewModel.logoutUser)
                    .frame(maxWidth: .infinity)
                    .customButton(fillColor: .clear, borderWidth: 3)
            }
            .scrollContentBackground(.hidden)
        }
        .padding()
    }
}

#Preview {
    MenuView(authViewModel: .constant(FirebaseAuthViewModel()))
}
