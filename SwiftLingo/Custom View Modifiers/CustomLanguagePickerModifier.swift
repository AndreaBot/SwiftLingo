//
//  CustomLanguagePicker.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 18/05/2024.
//

import SwiftUI

struct CustomLanguagePickerModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(5)
            .tint(.primary)
            .background(.secondary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

extension View {
    func customLanguagePicker() -> some View {
        modifier(CustomLanguagePickerModifier())
    }
}
