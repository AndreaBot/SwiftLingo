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
    
    @Binding var path: [NavigationScreens]
    
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Image(systemName: "swift")
                    .font(.largeTitle)
                
                Spacer()
                
                TextField("Email", text: $email, prompt: Text("Enter your email"))
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                VStack(alignment: .leading) {
                    PasswordTextField(password: $password, prompt: "Type your password here")
                    PasswordRating(password: $password)
                }
                PasswordTextField(password: $passwordConfirmation, prompt: "Confirm your password")
                
                Spacer()
                
                Button("Register") {
                    registerUser()
                }
                .foregroundStyle(.white)
                //.disabled(email.isEmpty || password.isEmpty)
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            
        } message: {
            Text(alertMessage)
        }

    }
    
    func registerUser() {
        
        guard email != "", password != "", passwordConfirmation != "" else {
            alertMessage = "One or more fields have not been filled in"
            showingAlert = true
            return
        }
        
        guard passwordConfirmation == password else {
            alertMessage = "The passwords do not match."
            showingAlert = true
            return
        }
        
        guard password.count >= 6 else {
            alertMessage = "Your password must be at least 6 characters long"
            showingAlert = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e)
            } else {
                path.append(.mainAppView)
            }
        }
    }
}

#Preview {
    RegisterView(path: .constant([.loginOptions, .registerView]))
}
