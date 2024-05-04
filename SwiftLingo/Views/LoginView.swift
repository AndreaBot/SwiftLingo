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
    
    @Binding var path: [NavigationScreens]
    
    @State private var email = ""
    @State private var password = ""
    
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
                PasswordTextField(password: $password, prompt: "Type your password here")
                
                Spacer()
                
                Button("Login") {
                    loginUser()
                }
                .foregroundStyle(.white)
                .disabled(email.isEmpty || password.isEmpty)
            }
        }
    }
    
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e)
            } else {
                path.append(.mainAppView)
            }
        }
    }
}

#Preview {
    LoginView(path: .constant([.loginOptions, .loginView]))
}
