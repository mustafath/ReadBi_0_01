//
//  TranslationAPIConfig.swift
//  ReadBi_0_01
//
//  Created by Mustafa Girgin on 30.03.2023.
//

import Foundation
import SwiftUI



struct TranslationAPIConfig {
    static let apiKey = APIConstants.apiKey
    static let baseURL = "https://translation.googleapis.com"
    static let translatePath = "/language/translate/v2"
    var sourceLang: String
    var targetLang: String
    
    init(sourceLang: String = LanguageSettings.sourceLang ?? "en", targetLang: String = LanguageSettings.targetLang ?? "tr") {
            self.sourceLang = sourceLang
            self.targetLang = targetLang
        }
    
    
}
