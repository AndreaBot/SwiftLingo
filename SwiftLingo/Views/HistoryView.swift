//
//  HistoryView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 07/05/2024.
//

import SwiftUI

struct HistoryView: View {
    
    @Binding var translatorViewModel: TranslatorViewModel
    
    var body: some View {
        List(translatorViewModel.history) {
            Text($0.translation)
        }
    }
}

//#Preview {
//    HistoryView()
//}
