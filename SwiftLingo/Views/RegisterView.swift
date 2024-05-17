//
//  RegisterView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 02/05/2024.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI

struct RegisterView: View {
    
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
                
                VStack(alignment: .leading) {
                    PasswordTextField(password: $viewModel.password, prompt: "Enter your password")
                    
                    if !viewModel.password.isEmpty {
                        PasswordRating(password: $viewModel.password)
                    }
                }
                PasswordTextField(password: $viewModel.passwordConfirmation, prompt: "Confirm your password")
            }
            .padding()
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer()
            
            Button {
                viewModel.registerUser()
            } label: {
                Text("Register")
                    .frame(maxWidth: .infinity)
            }
            .foregroundStyle(.background)
            .customButton(fillColor: .blue, borderWidth: 0)
        }
        .padding()
        .onAppear {
            viewModel.resetFields()
            focus = true
        }
        .alert("Error", isPresented: $viewModel.showingErrorAlert) {} message: {
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
//    RegisterView(path: .constant([.loginOptions, .registerView]))
//}
