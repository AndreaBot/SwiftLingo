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
    @State private var showingMenu = false
    
    @State private var selectedTab = 0
    @State private var screenTitles = ["Translator", "Saved translations"]
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TranslatorView(firestoreViewModel: $firestoreViewModel, translatorViewModel: $translatorViewModel)
                .tabItem {
                    Label("Translator", systemImage: "bubble.left.and.text.bubble.right")
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
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    showingHistory = true
                } label: {
                    Image(systemName: "clock.arrow.2.circlepath")
                }
                Button {
                    if firestoreViewModel.currentUser != nil {
                        showingMenu = true
                    } else {
                        viewModel.path.removeAll()
                    }
                    
                } label: {
                    Image(systemName: firestoreViewModel.currentUser != nil ? "ellipsis" : "rectangle.portrait.and.arrow.forward")
                }
            }
        }
        .fullScreenCover(isPresented: $showingHistory) {
            HistoryView(translatorViewModel: $translatorViewModel, firestoreViewModel: $firestoreViewModel)
        }
        .sheet(isPresented: $showingMenu) {
            MenuView(authViewModel: $viewModel)
                .presentationDetents([.fraction(0.33)])
        }
        .onAppear {
            translatorViewModel.loadHistoryUserDefaults()
            
            //COMMENTED OUT TO PRESERVE LOGIN DETAILS FOR RECRUITERS. IF I WAS TO SHIP THIS APP RESETTING THE FIELD WOULD PROVIDE A BETTER EXPERIENCE
           // viewModel.resetFields()
        }
    }
}

#Preview {
    @State var viewModel = FirebaseAuthViewModel()
    return MainAppView(viewModel: $viewModel)
}
