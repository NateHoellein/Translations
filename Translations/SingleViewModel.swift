//
//  SingleViewModel.swift
//  Translations
//
//  Created by nate on 10/7/24.
//

import Foundation
import Translation

@Observable
class SingleViewModel {
    var title = ""
    var body = ""
    var translatedText = ""
    var errorMessages: String? = nil
    
    var availableLanguages: [AvailableLanguage] = []
    
    init() {
        self.title = "Title For the Single Translation"
        self.body = "Translation framework supports a wide variety of langugages making it easy to translate your app into multiple languages."
        prepareSupportedLanguages()
    }
    
    func prepareSupportedLanguages() {
        Task { @MainActor in
            let supportedLanguages = await LanguageAvailability().supportedLanguages
            availableLanguages = supportedLanguages.map {
                AvailableLanguage(locale: $0)
            }.sorted()
        }
    }
    
    func translate(text: String, using session: TranslationSession) async {
        do {
            let response = try await session.translate(text)
            translatedText = response.targetText
        } catch {
            errorMessages = "error translating: \(error.localizedDescription)"
        }
    }
}
