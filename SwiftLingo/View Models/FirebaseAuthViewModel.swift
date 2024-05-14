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
    var newPassword = ""
    
    var alertTitle = ""
    var alertMessage = ""
    var showingAlert = false
    var showingConfirmationAlert = false
    var showingPasswordResetAlert = false
    var showingReauthenticationError = false
    
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
            path.removeAll()
        } catch let e as NSError {
            self.alertMessage = e.localizedDescription
            self.showingAlert = true
        }
    }
    
    func deleteAccountChecking() {
        alertTitle = "Hold on a sec..."
        alertMessage = "Do you wish to delete your account? This action cannot be undone!"
        showingConfirmationAlert = true
    }
    
    func deleteAccount() {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    self.alertTitle = "Error"
                    self.alertMessage = error.localizedDescription
                    self.showingConfirmationAlert = true
                } else {
                    self.path.removeAll()
                }
            }
        }
    }
    
    func resetPassword() {
        if let user = Auth.auth().currentUser {
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    self.alertTitle = "Error"
                    self.alertMessage = error.localizedDescription
                    self.showingPasswordResetAlert = true
                }
            }
        }
    }
    
    func reAuthenticate(password: String, confirmationFunc: @escaping () -> Void) {
        if let user = Auth.auth().currentUser {
            let credential = EmailAuthProvider.credential(withEmail: user.email! , password: password)
            user.reauthenticate(with: credential) { _ , error in
                if let error = error {
                    print(error)
                    self.showingReauthenticationError = true
                    self.password = ""
                } else {
                    confirmationFunc()
                }
            }
        }
    }
    
    func resetFields() {
        email = ""
        password = ""
        passwordConfirmation = ""
        newPassword = ""
    }
}

