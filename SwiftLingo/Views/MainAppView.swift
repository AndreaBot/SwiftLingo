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
    
    @State private var selectedTab = 0
    @State private var screenTitles = ["Translator", "My Translations"]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TranslatorView(firestoreViewModel: $firestoreViewModel, translatorViewModel: $translatorViewModel)
                .tabItem {
                    Label("SwiftLingo", systemImage: "swift")
                }
                .tag(0)
            
            SavedTranslationsView(firestoreViewModel: $firestoreViewModel)
                .tabItem {
                    Label("Saved translations", systemImage: "heart")
                }
                .tag(1)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text(screenTitles[selectedTab])
                    .font(.title)
                    .fontDesign(.rounded)
            }
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
        .fullScreenCover(isPresented: $showingHistory, content: {
            HistoryView(translatorViewModel: $translatorViewModel, firestoreViewModel: $firestoreViewModel)
        })
        .onAppear {
            translatorViewModel.loadUserDefaults()
        }
    }
}

//#Preview {
//    MainAppView(path: .constant([.loginOptions, .mainAppView]))
//}
