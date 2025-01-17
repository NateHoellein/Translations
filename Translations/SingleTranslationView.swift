//
//  SingleTranslationView.swift
//  Translations
//
//  Created by nate on 10/7/24.
//

import SwiftUI
import Translation

struct SingleTranslationView: View {
    @State private var titleTranslation = false
    @State private var bodyTranslation = false
    
    var viewModel: SingleViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.title)
            Button("Translate") {
                titleTranslation.toggle()
            }
            .translationPresentation(isPresented: $titleTranslation, text: viewModel.title)
            .padding()
            Text(viewModel.body)
            Button("Translate") {
                bodyTranslation.toggle()
            }
            .translationPresentation(isPresented: $bodyTranslation, text: viewModel.body)
            .padding()
            Text(viewModel.errorMessages ?? "")
        }
    }
}
