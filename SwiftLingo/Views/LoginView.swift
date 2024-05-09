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
    @FocusState var focus: Bool
    
    var body: some View {
        VStack {
            Spacer()
            SwiftLingoView()
            Spacer()
            
            VStack(spacing: 30) {
                TextField("Email", text: $viewModel.email, prompt: Text("Enter your email").foregroundStyle(.gray.secondary))
                    .padding()
                    .foregroundStyle(.black)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .focused($focus)
                PasswordTextField(password: $viewModel.password, focus: $focus, prompt: "Enter your password")
            }
            .padding()
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer()
            
            Button {
                viewModel.loginUser()
            } label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
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
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        focus = false
                    }
                }
            }
        }
    }
}

//#Preview {
//    LoginView(path: .constant([.loginOptions, .loginView]))
//}
