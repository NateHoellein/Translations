//
//  BatchViewModel.swift
//  Translations
//
//  Created by nate on 10/7/24.
//

import Foundation
import Translation

@Observable
class BatchViewModel {
    var title = ""
    var body = ""
    var errorMessages: String? = nil
    
    var translateFrom: Locale.Language?
    var translateTo: Locale.Language?
    var isTranslationSupported: Bool?
    var availableLanguages: [AvailableLanguage] = []
    
    init() {
        self.title = "Title For the Single Translation"
        self.body = "Translation framework supports a wide variety of langugages making it easy to translate your app into multiple languages."
        prepareSupportedLanguages()
    }
    
    func reset() {
        isTranslationSupported = nil
    }
    
    func prepareSupportedLanguages() {
        Task { @MainActor in
            let supportedLanguages = await LanguageAvailability().supportedLanguages
            availableLanguages = supportedLanguages.map {
                AvailableLanguage(locale: $0)
            }.sorted()
        }
    }
    
    func checkLanguageSupport(from source: Locale.Language, to target: Locale.Language) async {
        translateFrom = source
        translateTo = target
        
        guard let translateFrom = translateFrom else { return }
        
        let status = await LanguageAvailability().status(from: translateFrom, to: translateTo)
        
        switch status {
            
        case .installed, .supported:
            isTranslationSupported = true
        case .unsupported:
            isTranslationSupported = false
        @unknown default:
            errorMessages = "Translation support status for the selected language pair is unkown"
        }
    }
    
    func translateAllAtOnce(using session: TranslationSession) async {
        let requests: [TranslationSession.Request] = [
            TranslationSession.Request(sourceText: title),
            TranslationSession.Request(sourceText: body)
        ]
        
        do {
            let response = try await session.translations(from: requests)
            title = response.first?.targetText ?? title
            body = response.last?.targetText ?? body
        } catch {
            errorMessages = "Error executing translation request \(error.localizedDescription)"
        }
    }
}
