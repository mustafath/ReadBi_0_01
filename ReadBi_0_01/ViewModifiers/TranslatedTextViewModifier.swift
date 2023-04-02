//
//  TranslatedTextView.swift
//  ReadBi_0_01
//
//  Created by Mustafa Girgin on 30.03.2023.
//

import SwiftUI

struct TranslatedTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(TranslationBoxConstants.textColor)
            .font(TranslationBoxConstants.textFont)
            .multilineTextAlignment(TranslationBoxConstants.textAlignment)
            .frame(minWidth: TranslationBoxConstants.minFrameWidth, minHeight: TranslationBoxConstants.minFrameHeight)
            .padding(TranslationBoxConstants.padding)
            .background(TranslationBoxConstants.background, in: RoundedRectangle(cornerRadius: TranslationBoxConstants.cornerRadius))
            .padding()
            .shadow(color: TranslationBoxConstants.shadowColor, radius: TranslationBoxConstants.shadowRadius, y: TranslationBoxConstants.shadowY)
            .position(x: TranslationBoxConstants.positionX, y: TranslationBoxConstants.positionY)
    }
}

extension View {
    func translatedTextStyle() -> some View {
        self.modifier(TranslatedTextStyle())
    }
}
