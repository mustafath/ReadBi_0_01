//
//  LanguageSettings.swift
//  ReadBi_0_01
//
//  Created by Mustafa Girgin on 30.03.2023.
//

import Foundation

struct LanguageSettings {
    static var sourceLang: String? {
        get {
            return UserDefaults.standard.string(forKey: "sourceLang")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "sourceLang")
        }
    }
    
    static var targetLang: String? {
        get {
            return UserDefaults.standard.string(forKey: "targetLang")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "targetLang")
        }
    }
    
    static func reset() {
        sourceLang = nil
        targetLang = nil
    }
}

struct TranslationSettings {
    var sourceLang: String = "tr"
    var targetLang: String = "en"
    
    mutating func saveSettings(sourceLang: String, targetLang: String) {
        LanguageSettings.sourceLang = sourceLang
        LanguageSettings.targetLang = targetLang
        
    }
    
    mutating func loadSettings() {
        // Burada kaydedilmiş sourceLang ve targetLang değerlerini yükleyerek, TranslationAPIConfig struct'ını güncelleyebilirsiniz.
        let savedSourceLang = LanguageSettings.sourceLang // Örnek olarak sabit bir değer atıyoruz
        let savedTargetLang = LanguageSettings.targetLang // Örnek olarak sabit bir değer atıyoruz
        
        sourceLang = savedSourceLang != nil ? savedSourceLang! : "en"
        targetLang = savedTargetLang != nil ? savedTargetLang! : "tr"
    }
}
