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
    var rows: [RowData] = []
    var errorMessages: String? = nil
    
    var translateFrom: Locale.Language?
    var translateTo: Locale.Language?
    var isTranslationSupported: Bool?
    var availableLanguages: [AvailableLanguage] = []
    
    init() {
        buildRowData()
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
        let rowrequests: [[TranslationSession.Request]] = rows.map { row in
            return [TranslationSession.Request(sourceText: row.title, clientIdentifier: "\(row.id).1"),
                    TranslationSession.Request(sourceText: row.subtitle, clientIdentifier: "\(row.id).2")]
        }
        let requests: [TranslationSession.Request] = Array(rowrequests.joined())

        do {
            let response = try await session.translations(from: requests)
            response.forEach { response in
                let rowid = response.clientIdentifier!.split(separator: ".")
                let id = Int(rowid[0])!
                let idIndex = id - 1
                if rowid.last == "1" {
                    rows[idIndex].title = response.targetText
                }
                if rowid.last == "2" {
                    rows[idIndex].subtitle = response.targetText
                }
            }
        } catch {
            errorMessages = "Error executing translation request \(error.localizedDescription)"
        }
    }
    
    func buildRowData() {
        let row1 =  RowData(id: 1, image: "keyboard.chevron.compact.down",
                            title: "Vintage Typewriter",
                            subtitle: "A classic writing machine, often from the early 20th century, with keys that clack and a nostalgic charm.")
        let row2 =  RowData(id: 2, image: "cooktop.fill",
                            title: "Slice of Pepperoni Pizza",
                            subtitle: "A delicious, cheesy treat topped with savory slices of pepperoni, often enjoyed hot and fresh from the oven.")
        let row3 =  RowData(id: 3, image: "cube.transparent",
                            title: "Colorful Rubik's Cube",
                            subtitle: "A 3D combination puzzle featuring six faces of different colors, challenging players to align each side with one solid color")
        let row4 =  RowData(id: 4, image: "cone.fill",
                            title: "Cactus in a Quirky Pot",
                            subtitle: "A low-maintenance succulent housed in a fun, decorative pot, adding a touch of desert flair to any space.")
        let row5 =  RowData(id: 5, image: "figure.socialdance.circle.fill",
                            title: "Funky Socks",
                            subtitle: "Brightly patterned or uniquely designed socks that add personality to an outfit, often featuring whimsical prints or bold colors.")
        rows.append(row1)
        rows.append(row2)
        rows.append(row3)
        rows.append(row4)
        rows.append(row5)
    }
}
struct RowData: Identifiable {
    let id: Int
    let image: String
    var title: String
    var subtitle: String
}
