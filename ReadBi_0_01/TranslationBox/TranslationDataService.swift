//
//  TranslationDataService.swift
//  ReadBi_0_01
//
//  Created by Mustafa Girgin on 28.03.2023.
//

import Foundation
import Combine

class TranslationDataService {
    
    @Published var translation: String = ""
    @Published var isTranslating: Bool? = false
    var translationSubscription: AnyCancellable?
    var isTranslatingSubscription: AnyCancellable?

    var settings: TranslationSettings
    
    init() {
        settings = TranslationSettings()
        settings.loadSettings()
    }
    
    public func getTranslation(text: String) {
        
        let apiKey = TranslationAPIConfig.apiKey
        let sourceLang = settings.sourceLang
        let targetLang = settings.targetLang
        
        let parameters = [
            "q": text,
            "source": sourceLang,
            "target": targetLang
        ]
        
        isTranslating = true
        let urlString = "\(TranslationAPIConfig.baseURL)\(TranslationAPIConfig.translatePath)?key=\(TranslationAPIConfig.apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        translationSubscription = NetworkingManager.downloadAF(url: url, parameters: parameters)
            .decode(type: TranslationResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion(completion:),
                  receiveValue: { [weak self] translationResponse in
                    let translation = translationResponse.data.translations.first
                    guard let translation = translation?.translatedText else { return }
                self?.translation = translation.decodeHTMLEntities()
                    self?.isTranslating = false
            })
    }
}
