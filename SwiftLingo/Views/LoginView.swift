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
        VStack {
            Spacer()
            Image(systemName: "swift")
                .font(.largeTitle)
            
            Spacer()
            
            VStack(spacing: 30) {
                TextField("Email", text: $email, prompt: Text("Enter your email").foregroundStyle(.gray.secondary))
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                PasswordTextField(password: $password, prompt: "Enter your password")
            }
            .padding()
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer()
            
            Button {
                loginUser()
            } label: {
                Text("Login")
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size * 0.85
                    }
                    .padding(.vertical, 5)
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.background)
        }
        .padding()
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
