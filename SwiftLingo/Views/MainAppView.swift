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
    @State private var translatorViewModel = TranslatorViewModel()
    @State private var firestoreViewModel = FirestoreViewModel()
    
    @State private var showingHistory = false
    
    var body: some View {
        TabView {
            TranslatorView(firestoreViewModel: $firestoreViewModel, translatorViewModel: $translatorViewModel)
                .tabItem {
                    Label("SwiftLingo", systemImage: "swift")
                }
            
            SavedTranslationsView(firestoreViewModel: $firestoreViewModel)
                .tabItem {
                    Label("Saved translations", systemImage: "heart")
                }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    showingHistory = true
                } label: {
                    Image(systemName: "clock.arrow.2.circlepath")
                }
                if Auth.auth().currentUser != nil {
                        Button {
                            viewModel.logoutUser()
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                        }
                }
            }
            
        }
        .alert("Error", isPresented: $viewModel.showingAlert) {} message: {
            Text(viewModel.alertMessage)
        }
        .sheet(isPresented: $showingHistory, content: {
            HistoryView(translatorViewModel: $translatorViewModel)
        })
        .onAppear {
            translatorViewModel.loadUserDefaults()
        }
    }
}

//#Preview {
//    MainAppView(path: .constant([.loginOptions, .mainAppView]))
//}
