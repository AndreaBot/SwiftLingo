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
    
    @Binding var path: [NavigationScreens]
    
    var body: some View {
        TabView {
            TranslatorView()
                .tabItem {
                    Label("SwiftLingo", systemImage: "swift")
                }
        }
        .toolbar {
            if Auth.auth().currentUser != nil {
                ToolbarItem(placement: .primaryAction) {
                    Button("Logout") {
                        logoutUser()
                    }
                }
            }
        }
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            path.removeAll()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

#Preview {
    MainAppView(path: .constant([.loginOptions, .mainAppView]))
}
