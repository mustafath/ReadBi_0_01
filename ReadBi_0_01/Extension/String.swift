//
//  String.swift
//  ReadBi_0_01
//
//  Created by Mustafa Girgin on 30.03.2023.
//

import Foundation

extension String {
    /// This function decodes HTML entities in a string and returns the decoded string.
    func decodeHTMLEntities() -> String {
        var decodedString = self
        decodedString = decodedString.replacingOccurrences(of: "&quot;", with: "\"")   /// Decode the " character
        decodedString = decodedString.replacingOccurrences(of: "&apos;", with: "'")   /// Decode the ' character
        decodedString = decodedString.replacingOccurrences(of: "&amp;", with: "&")    /// Decode the & character
        decodedString = decodedString.replacingOccurrences(of: "&lt;", with: "<")    /// Decode the  < character
        decodedString = decodedString.replacingOccurrences(of: "&gt;", with: ">")    /// Decode the > character
        decodedString = decodedString.replacingOccurrences(of: "&nbsp;", with: " ")  /// Decode the non-breaking space character
        decodedString = decodedString.replacingOccurrences(of: "&#39;", with: "'")   /// Decode the ' character
        return decodedString
    }
}


