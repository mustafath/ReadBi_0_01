//
//  Translation.swift
//  ReadBi_0_01
//
//  Created by Mustafa Girgin on 28.03.2023.
//

import Foundation


struct TranslationResponse: Codable {
    let data: TranslationData
}

struct TranslationData: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let translatedText: String
}
