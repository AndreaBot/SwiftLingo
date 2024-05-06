//
//  FirebaseAuthModel.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 06/05/2024.
//

import FirebaseAuth
import Foundation


@Observable
final class FirebaseAuthViewModel {
    
    var path = [NavigationScreens]()
    
    var email = ""
    var password = ""
    var passwordConfirmation = ""
    
    var alertMessage = ""
    var showingAlert = false
    
    func checkCurrentUser() {
        if Auth.auth().currentUser == nil {
            self.path.append(.loginOptions)
        } else {
            self.path.append(.mainAppView)
        }
    }
    
    func registerUser() {
        guard passwordConfirmation == password else {
            alertMessage = "The passwords do not match."
            showingAlert = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                self.alertMessage = e.localizedDescription
                self.showingAlert = true
            } else {
                self.path.append(.mainAppView)
            }
        }
    }
    
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                self.alertMessage = e.localizedDescription
                self.showingAlert = true
            } else {
                self.path.append(.mainAppView)
            }
        }
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            self.path.removeAll()
        } catch let e as NSError {
            self.alertMessage = e.localizedDescription
            self.showingAlert = true
        }
    }
    
    func resetFields() {
        email = ""
        password = ""
        passwordConfirmation = ""
    }
}
