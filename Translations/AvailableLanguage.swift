//
//  AvailableLanguage.swift
//  Translations
//
//  Created by nate on 10/7/24.
//

import Foundation

struct AvailableLanguage: Identifiable, Hashable, Comparable {
    var id: Self { self }
    let locale: Locale.Language
    
    func localizedName() -> String {
        let local = Locale.current
        let shortName = shortName()
        
        guard let localizedName = local.localizedString(forLanguageCode: shortName) else {
            return "unknown language code"
        }
        
        return "\(localizedName)-\(shortName)"
    }
    
    private func shortName() -> String {
        "\(locale.languageCode ?? "")-\(locale.region ?? "")"
    }
    
    static func < (lhs: AvailableLanguage, rhs: AvailableLanguage) -> Bool {
        return lhs.localizedName() == rhs.localizedName()
    }
}
