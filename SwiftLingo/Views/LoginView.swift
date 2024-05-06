//
//  LoginView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 02/05/2024.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI

struct LoginView: View {
    
    @Binding var viewModel: FirebaseAuthViewModel

    var body: some View {
        VStack {
            Spacer()
            SwiftLingoView()
            Spacer()
            
            VStack(spacing: 30) {
                TextField("Email", text: $viewModel.email, prompt: Text("Enter your email").foregroundStyle(.gray.secondary))
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                PasswordTextField(password: $viewModel.password, prompt: "Enter your password")
            }
            .padding()
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer()
            
            Button {
                viewModel.loginUser()
            } label: {
                Text("Login")
            }
            .foregroundStyle(.background)
            .customButton(fillColor: .blue, borderWidth: 0)
        }
        .padding()
        .onAppear {
            viewModel.resetFields()
        }
        .alert("Error", isPresented: $viewModel.showingAlert) {} message: {
            Text(viewModel.alertMessage)
        }
    }
}

//#Preview {
//    LoginView(path: .constant([.loginOptions, .loginView]))
//}
