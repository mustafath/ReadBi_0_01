//
//  PDFmodel.swift
//  ReadBi_0_01
//
//  Created by Mustafa Girgin on 1.04.2023.
//

import Foundation
import SwiftUI
import PDFKit
import SwiftUI

struct PDFModel: Identifiable {
    let id = UUID().uuidString
    let title: String?
    let url: URL
    let image : Image?
    
    
    init(title: String?, url: URL, image: Image?) {
        self.title = title
        self.url = url
        self.image = image
    }
    

   


    
    
    
}
