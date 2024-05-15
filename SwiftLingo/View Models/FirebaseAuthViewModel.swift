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
    
    var alertMessage = ""
    var showingAccountDeletionAlert = false
    var showingPasswordResetAlert = false
    var showingSendLinkAlert = false
    var showingErrorAlert = false
    
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
            showingErrorAlert = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                self.alertMessage = e.localizedDescription
                self.showingErrorAlert = true
            } else {
                self.path.append(.mainAppView)
            }
        }
    }
    
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                self.alertMessage = e.localizedDescription
                self.showingErrorAlert = true
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
            self.showingErrorAlert = true
        }
    }
    
    func deleteAccountChecking() {
        alertMessage = "Do you wish to delete your account? This action cannot be undone!"
        showingAccountDeletionAlert = true
    }
    
    func deleteAccount() {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    self.alertMessage = error.localizedDescription
                    self.showingErrorAlert = true
                } else {
                    self.path.removeAll()
                }
            }
        }
    }
    
    func resetPasswordChecking() {
        alertMessage = "Confirm your current password and type the new one to proceed"
        showingPasswordResetAlert = true
    }
    
    func resetPassword() {
        if let user = Auth.auth().currentUser {
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    self.alertMessage = error.localizedDescription
                    self.showingErrorAlert = true
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
                    self.alertMessage = "We couldn't prove you identity with the credentials provided. Please double check them and try again"
                    self.showingErrorAlert = true
                    self.password = ""
                    self.newPassword = ""
                } else {
                    confirmationFunc()
                }
            }
        }
    }
    
    func sendPasswordResetEmail() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print(error.localizedDescription)
                self.alertMessage = error.localizedDescription
                self.showingErrorAlert = true
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

