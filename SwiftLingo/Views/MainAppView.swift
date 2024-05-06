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
    @State private var firestoreViewModel = FirestoreViewModel()
    
    var body: some View {
        TabView {
            TranslatorView(firestoreViewModel: $firestoreViewModel)
                .tabItem {
                    Label("SwiftLingo", systemImage: "swift")
                }
            
            SavedTranslationsView(firestoreViewModel: $firestoreViewModel)
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
