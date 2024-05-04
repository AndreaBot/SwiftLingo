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
                TextField("Password", text: $password, prompt: Text("Enter your password"))
                
                Spacer()
                
                Button("Register") {
                    registerUser()
                }
                .foregroundStyle(.white)
                .disabled(email.isEmpty || password.isEmpty)
            }
        }
    }
    
    func registerUser() {
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
