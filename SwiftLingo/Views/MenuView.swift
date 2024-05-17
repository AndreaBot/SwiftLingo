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
            Button("Logout") {
                dismiss()
                authViewModel.logoutUser()
            }
                .frame(maxWidth: .infinity)
                .customButton(fillColor: .clear, borderWidth: 3)
            
            Button("Delete account", action: authViewModel.deleteAccountChecking)
                .frame(maxWidth: .infinity)
                .customButton(fillColor: .clear, borderWidth: 3)
                .alert("Account deletion", isPresented: $authViewModel.showingAccountDeletionAlert) {
                    TextField("", text: $authViewModel.password, prompt: Text("Confirm your password"))
                    Button("Delete account") {
                        authViewModel.reAuthenticate(password: authViewModel.password, confirmationFunc: authViewModel.deleteAccount)
                    }
                    .disabled(authViewModel.password.isEmpty)
                    Button("Cancel") {}
                } message: {
                    Text(authViewModel.alertMessage)
                }
            
            
            Button("Reset password", action: authViewModel.resetPasswordChecking)
                .frame(maxWidth: .infinity)
                .customButton(fillColor: .clear, borderWidth: 3)
                .alert("Password reset", isPresented: $authViewModel.showingPasswordResetAlert) {
                    SecureField("Currect password", text: $authViewModel.password, prompt: Text("Confirm your current password"))
                    SecureField("New password", text: $authViewModel.newPassword, prompt: Text("Enter your new password"))
                    Button("Reset password") {
                        authViewModel.reAuthenticate(password: authViewModel.password, confirmationFunc: authViewModel.resetPassword)
                    }
                    .disabled(authViewModel.password.isEmpty || authViewModel.newPassword.isEmpty)
                    Button("Cancel") {}
                } message: {
                    Text(authViewModel.alertMessage)
                }
        }
        .padding()
        .alert("Error", isPresented: $authViewModel.showingMenuErrorAlert) {
        } message: {
            Text(authViewModel.alertMessage)
        }
    }
}

#Preview {
    MenuView(authViewModel: .constant(FirebaseAuthViewModel()))
}
