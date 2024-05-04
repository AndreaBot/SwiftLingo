//
//  LoginOptionsView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 02/05/2024.
//

import SwiftUI

struct LoginOptionsView: View {
    @Binding var path: [NavigationScreens]
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "swift")
                .font(.largeTitle)
            
            Spacer()
            
            VStack(spacing: 30) {
                Button {
                    path.append(.registerView)
                } label: {
                    Text("Register")
                        .containerRelativeFrame(.horizontal) { size, axis in
                            size * 0.85
                        }
                        .padding(.vertical, 5)
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.background)
                
                Button {
                    path.append(.loginView)
                } label: {
                    Text("Login")
                        .containerRelativeFrame(.horizontal) { size, axis in
                            size * 0.84
                        }
                        .padding(12)
                        .foregroundColor(.blue)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 8,
                                style: .continuous
                            )
                            .stroke(.blue, lineWidth: 3)
                        )}
                
                Button {
                    path.append(.mainAppView)
                } label: {
                    Text("Continue as a guest")
                        .padding(.bottom)
                    
                }
                .buttonStyle(.borderless)
            }
            
            
        }
    }
}

#Preview {
    LoginOptionsView(path: .constant([.loginOptions]))
}
