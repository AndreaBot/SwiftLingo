//
//  DismissToolbar.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 08/05/2024.
//

import SwiftUI

struct DismissToolbar: View {
    
    var dismissAction: DismissAction
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                dismissAction()
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.title2)
            }
        }
    }
}

#Preview {
    @Environment(\.dismiss) var dismiss
    return DismissToolbar(dismissAction: dismiss)
}
