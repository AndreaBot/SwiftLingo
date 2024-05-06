//
//  LoginOptionsView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 02/05/2024.
//

import SwiftUI

struct LoginOptionsView: View {

    @Binding var viewModel: FirebaseAuthViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            SwiftLingoView()
            
            Spacer()
            
            VStack(spacing: 30) {
                Button {
                    viewModel.path.append(.registerView)
                } label: {
                    Text("Register")
                }
                .foregroundStyle(.background)
                .customButton(fillColor: .blue, borderWidth: 0)
                
                Button {
                    viewModel.path.append(.loginView)
                } label: {
                    Text("Login")
                }
                .foregroundStyle(.blue)
                .customButton(fillColor: .clear, borderWidth: 3)
                
                Button {
                    viewModel.path.append(.mainAppView)
                } label: {
                    Text("Continue as a guest")
                        .font(.headline)
                        .padding(.bottom)
                    
                }
            }
        }
    }
}

//#Preview {
//    LoginOptionsView(path: .constant([.loginOptions]))
//}
