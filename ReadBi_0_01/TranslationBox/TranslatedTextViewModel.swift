//
//  TranslatedTextViewModel.swift
//  ReadBi_0_01
//
//  Created by Mustafa Girgin on 28.03.2023.
//


import Foundation
import PDFKit
import SwiftUI
import Combine
import UIKit



class TranslateTextViewModel : ObservableObject {
    
    @Published var selectedString : String? = nil
    @Published var isTranslating : Bool? = false
    
    private var cancellables = Set<AnyCancellable>();
    private let translationService  = TranslationDataService()
    
    init() {
        addObserver()
        addSubscriber()
        
    }
    
    @objc func doNothing() {}
    
    
    func addObserver() {
            NotificationCenter.default.addObserver(
                forName: .PDFViewSelectionChanged, object: nil, queue: nil
            ) { notification in
                if let pdfView = notification.object as? PDFView {
                    
                    let selection = pdfView.currentSelection
                    if (selection?.string?.count ?? 0 > 240) {return}
                    self.translationService.getTranslation(text: selection?.string ?? "")
                    self.selectedString = self.translationService.translation
                    self.isTranslating = self.translationService.isTranslating
                    print("Selected text: \(self.translationService.translation)")
                    
                }
                
            }
        }

    
    func addSubscriber() {
        self.translationService.$translation
            .combineLatest(translationService.$isTranslating)
            .sink { [weak self] (translatedText, isTranslating) in
                self?.selectedString = translatedText
                self?.isTranslating = isTranslating
                print(isTranslating)
            }
            .store(in: &cancellables)
    }
    
    
}
