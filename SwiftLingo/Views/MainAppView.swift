//
//  MainAppView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 02/05/2024.
//

import FirebaseCore
import FirebaseAuth
import SwiftUI

struct MainAppView: View {

    @Binding var viewModel: FirebaseAuthViewModel
    
    var body: some View {
        TabView {
            TranslatorView()
                .tabItem {
                    Label("SwiftLingo", systemImage: "swift")
                }
            
            SavedTranslationsView()
                .tabItem {
                    Label("Saved translations", systemImage: "heart")
                }
        }
        .toolbar {
            if Auth.auth().currentUser != nil {
                ToolbarItem(placement: .primaryAction) {
                    Button("Logout") {
                        viewModel.logoutUser()
                    }
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showingAlert) {} message: {
            Text(viewModel.alertMessage)
        }
    }
}

//#Preview {
//    MainAppView(path: .constant([.loginOptions, .mainAppView]))
//}
