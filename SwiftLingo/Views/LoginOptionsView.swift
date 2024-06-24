//
//  LoginOptionsView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 02/05/2024.
//

import SwiftUI

struct LoginOptionsView: View {
    
    @Binding var viewModel: FirebaseAuthViewModel
    
    @State private var showingWelcomeMessage = false
    
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
                        .frame(maxWidth: .infinity)
                }
                .foregroundStyle(.background)
                .customButton(fillColor: .blue, borderWidth: 0)
                
                Button {
                    viewModel.path.append(.loginView)
                } label: {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                }
                .foregroundStyle(.blue)
                .customButton(fillColor: .clear, borderWidth: 3)
                
                Button {
                    viewModel.path.append(.mainAppView)
                } label: {
                    Text("Continue as a guest")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .padding(.bottom)
                    
                    
                }
            }
        }
        .onAppear {
            showingWelcomeMessage = true
        }
        //MESSAGE FOR RECRUITERS
        .alert("Welcome 👋🏻", isPresented: $showingWelcomeMessage) {
        } message: {
            Text("Thank you for checking out this app! Feel free to login with the details shown on the login screen, I have also saved some sample data for that account, or create a new account too if you wish! \nI only have 50 free API calls per month so please bare that in mind when performing translations, cheers!")
        }
    }
}

#Preview {
    @State var authViewModel = FirebaseAuthViewModel()
    return LoginOptionsView(viewModel: $authViewModel)
}
