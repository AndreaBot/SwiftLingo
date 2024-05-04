//
//  PasswordTextField.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 04/05/2024.
//

import SwiftUI

struct PasswordTextField: View {
    
    @Binding var password: String
    @State private var showingPassword = false
    
    var body: some View {
        HStack {
            ZStack {
                if !showingPassword {
                    SecureField("Password", text: $password, prompt: Text("Type your password here"))
                        .padding()
                } else {
                    TextField("Password", text: $password, prompt: Text("Type your password here"))
                        .padding()
                }
            }
            
            Button {
                showingPassword.toggle()
            } label: {
                Image(systemName: showingPassword ? "eye" : "eye.slash")
            }
            .padding(.trailing)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    PasswordTextField(password: .constant("password"))
}
