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
    
    @State private var showingSplashScreen = true
    @State private var path = [NavigationScreens]()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                
                Image(systemName: "swift")
                    .font(.largeTitle)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    checkCurrentUser()
                }
            }
            .navigationDestination(for: NavigationScreens.self) { screen in
                if screen == .loginOptions {
                    LoginOptionsView(path: $path)
                        .navigationBarBackButtonHidden(true)
                } else if screen == .mainAppView {
                    MainAppView(path: $path)
                        .navigationBarBackButtonHidden(true)
                } else if screen == .registerView {
                    RegisterView(path: $path)
                } else if screen == .loginView {
                    LoginView(path: $path)
                }
            }
        }
    }
    
    func checkCurrentUser() {
        if Auth.auth().currentUser == nil {
            path.append(.loginOptions)
        } else {
            path.append(.mainAppView)
        }
    }
}

#Preview {
    SplashScreenView()
}
