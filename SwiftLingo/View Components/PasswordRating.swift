//
//  PasswordRating.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 04/05/2024.
//

import SwiftUI

struct PasswordRating: View {
    
    @Binding var password: String
    var rating: Int {
        var result = 0
        
        
        if password.count >= 8 {
            result += 1
        }
        
        if password.contains(where: { character in
            character.isUppercase
        }) {
            result += 1
        }
        
        if password.contains(where: { character in
            character.isNumber
        }) {
            result += 1
        }
        
        if password.contains(where: { character in
            character.isPunctuation || character.isSymbol || character.isCurrencySymbol
        }) {
            result += 1
        }
        
        return result
    }
    
    var body: some View {
        HStack {
            Text("Password strength:")
            if rating < 4 {
                ForEach(0...rating, id: \.self) { int in
                    
                    Image(systemName: "circle.fill")
                        .foregroundStyle(ratingColor())
                }
            } else {
                ForEach(0...rating, id: \.self) { int in
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                }
            }
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }
    
    
    func ratingColor() -> Color {
        switch rating {
        case 0: return .red;
        case 1: return .orange;
        case 2: return .yellow;
        case 3: return .green;
            
        default: return .green
        }
    }
}


#Preview {
    PasswordRating(password: .constant("passw1!ghjghjH"))
}

