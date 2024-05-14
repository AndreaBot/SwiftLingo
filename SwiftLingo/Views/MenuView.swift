//
//  MenuView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 13/05/2024.
//

import SwiftUI

struct MenuView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var authViewModel: FirebaseAuthViewModel
    
    
    var body: some View {
        VStack {
            DismissToolbar(dismissAction: dismiss)
            Spacer()
            Button("Logout", action: authViewModel.logoutUser)
                .frame(maxWidth: .infinity)
                .customButton(fillColor: .clear, borderWidth: 3)
            
            Button("Delete account", action: authViewModel.deleteAccountChecking)
                .frame(maxWidth: .infinity)
                .customButton(fillColor: .clear, borderWidth: 3)
            
            Button("Reset password") {
                authViewModel.showingPasswordResetAlert = true
            }
            .frame(maxWidth: .infinity)
            .customButton(fillColor: .clear, borderWidth: 3)
        }
        .padding()
        .alert(authViewModel.alertTitle, isPresented: $authViewModel.showingConfirmationAlert) {
            TextField("", text: $authViewModel.password, prompt: Text("Confirm your password"))
            Button("Delete account") {
                authViewModel.reAuthenticate(password: authViewModel.password, confirmationFunc: authViewModel.deleteAccount)
            }
            .disabled(authViewModel.password.isEmpty)
            Button("Cancel") {}
        } message: {
            Text(authViewModel.alertMessage)
        }
        .alert("Password reset", isPresented: $authViewModel.showingPasswordResetAlert) {
            SecureField("Currect password", text: $authViewModel.password, prompt: Text("Confirm your current password"))
            SecureField("Currect password", text: $authViewModel.newPassword, prompt: Text("Enter your new password"))
            Button("Reset password") {
                authViewModel.reAuthenticate(password: authViewModel.password, confirmationFunc: authViewModel.resetPassword)
            }
            .disabled(authViewModel.password.isEmpty || authViewModel.newPassword.isEmpty)
            Button("Cancel") {}
        } message: {
            Text("Confrim your current password and type the new one to proceed")
        }
        .alert("Error", isPresented: $authViewModel.showingReauthenticationError) {
        } message: {
            Text("We couldn't prove you identity with the credentials provided. Please double check them and try again")
        }
    }
}

#Preview {
    MenuView(authViewModel: .constant(FirebaseAuthViewModel()))
}
