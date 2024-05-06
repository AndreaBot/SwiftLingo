//
//  ContentView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 02/05/2024.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI

struct SplashScreenView: View {
    
    @State private var viewModel = FirebaseAuthViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            SwiftLingoView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        viewModel.checkCurrentUser()
                    }
                }
                .navigationDestination(for: NavigationScreens.self) { screen in
                    if screen == .loginOptions {
                        LoginOptionsView(viewModel: $viewModel)
                            .navigationBarBackButtonHidden(true)
                    } else if screen == .mainAppView {
                        MainAppView(viewModel: $viewModel)
                            .navigationBarBackButtonHidden(Auth.auth().currentUser != nil ? true : false)
                    } else if screen == .registerView {
                            RegisterView(viewModel: $viewModel)
                    } else if screen == .loginView {
                        LoginView(viewModel: $viewModel)
                    }
                }
        }
    }
}

#Preview {
    SplashScreenView()
}
