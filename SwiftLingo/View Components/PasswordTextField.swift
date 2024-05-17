//
//  PasswordTextField.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 04/05/2024.
//

import SwiftUI

struct PasswordTextField: View {
    
    @Binding var password: String
    var focus: FocusState<Bool>.Binding
    @State private var showingPassword = false
    
    let prompt: String
    
    var body: some View {
        HStack {
            ZStack {
                if !showingPassword {
                    SecureField("Password", text: $password, prompt: Text(prompt).foregroundStyle(.gray.secondary))
                        .padding()
                        .autocorrectionDisabled()
                        .focused(focus)
                        
                } else {
                    TextField("Password", text: $password, prompt: Text(prompt).foregroundStyle(.gray.secondary))
                        .padding()
                        .autocorrectionDisabled()
                        .focused(focus)
                }
            }
            .foregroundStyle(.black)
            
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

//#Preview {
//    let focus = false
//    return PasswordTextField(password: .constant("password"), focus: focus, prompt: "Type your password here")
//}
