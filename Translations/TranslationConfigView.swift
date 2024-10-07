//
//  TranslationConfigView.swift
//  Translations
//
//  Created by nate on 10/7/24.
//

import SwiftUI
import Translation

struct TranslationConfigView: View {
    
    @Environment(BatchViewModel.self) private var viewModel: BatchViewModel
    
    @State private var selectedFrom: Locale.Language?
    @State private var selectedTo: Locale.Language?
    
    var selectedLanguagePair: LanguagePair {
        LanguagePair(selectedFrom: selectedFrom, selectedTo: selectedTo)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select a source and target language")
            
            List {
                Picker("Source", selection: $selectedFrom) {
                    ForEach(viewModel.availableLanguages) { language in
                        Text(language.localizedName())
                            .tag(Optional(language.locale))
                    }
                }
                Picker("Target", selection: $selectedTo) {
                    ForEach(viewModel.availableLanguages) { language in
                        Text(language.localizedName())
                            .tag(Optional(language.locale))
                    }
                }
            }
            
            HStack {
                Spacer()
                if let supported = viewModel.isTranslationSupported {
                    Text(supported ? "✅" : "❌")
                        .font(.largeTitle)
                    if !supported {
                        Text("Translation between the same language doesn't work.")
                    }
                } else {
                    Image(systemName: "questionmark.circle")
                }
                Spacer()
            }
        }
        .onChange(of: selectedLanguagePair) {
            Task {
                await performCheck()
            }
        }
        .onDisappear() {
            viewModel.reset()
        }
        .padding()
        .navigationTitle("Translation Configuration").navigationBarTitleDisplayMode(.inline)
    }
    
    private func performCheck() async {
        guard let selectedFrom = selectedFrom else { return }
        guard let selectedTo = selectedTo else { return }
        
        await viewModel.checkLanguageSupport(from: selectedFrom, to: selectedTo)
    }
}

struct LanguagePair: Equatable {
    @State var selectedFrom: Locale.Language?
    @State var selectedTo: Locale.Language?
    
    static func == (lhs: LanguagePair, rhs: LanguagePair) -> Bool {
        lhs.selectedFrom == rhs.selectedFrom && lhs.selectedTo == rhs.selectedTo
    }
}
