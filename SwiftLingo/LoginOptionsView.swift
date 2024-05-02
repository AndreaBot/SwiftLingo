//
//  LoginOptionsView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 02/05/2024.
//

import SwiftUI

struct LoginOptionsView: View {
    @Binding var path: [NavigationScreens]
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            VStack {
                Spacer()
                Image(systemName: "swift")
                    .font(.largeTitle)
                
                Spacer()
                
                Button("Register") {
                    path.append(.registerView)
                }
                .padding()
                Button("Login") {
                    path.append(.loginView)
                }
                .padding()
                Button("Continue as a guest") {
                    path.append(.mainAppView)
                }
                .padding()
                
                
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    LoginOptionsView(path: .constant([.loginOptions]))
}
