//
//  BatchTranslationView.swift
//  Translations
//
//  Created by nate on 10/7/24.
//

import SwiftUI
import Translation

struct BatchTranslationView: View {
    @State var translateData = false
    @State private var configuration: TranslationSession.Configuration?
    
    @Environment(BatchViewModel.self) private var viewModel: BatchViewModel
    
    var body: some View {
        
        VStack {
            Text(viewModel.title)
                .padding()
            Text(viewModel.body)
                .padding()
            Text(viewModel.errorMessages ?? "")
            Menu("Translate Menu") {
                NavigationLink {
                    TranslationConfigView().environment(viewModel)
                } label: {
                    Text("Translate Config")
                }
                Button("All") {
                    translateAll()
                }
            }
            .menuStyle(.automatic)
        }
        .scenePadding()
        .translationTask(configuration) { session in
            Task {
                await viewModel.translateAllAtOnce(using: session)
            }
        }
    }
    
    private func translateAll() {
        if configuration == nil {
            configuration = .init(source: viewModel.translateFrom, target: viewModel.translateTo)
        } else {
            configuration?.invalidate()
        }
    }
}


#Preview {
    BatchTranslationView().environment(BatchViewModel())
}

