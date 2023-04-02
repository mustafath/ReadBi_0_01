//
//  PDFOverviewView.swift
//  ReadBi_0_01
//
//  Created by Mustafa Girgin on 1.04.2023.
//

import SwiftUI

struct PDFOverviewView: View {
    var pdfModel : PDFModel
    
    
    
    
    var body: some View {
        
            ZStack {
                HStack {
                    
                    pdfModel.image?
                        
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .foregroundColor(.accentColor)
                        .blur(radius: 30)
                    Spacer()
                        .frame(width: 30)
                    Text(pdfModel.title ?? "" )
                    Spacer()
                }.padding()
                
                RoundedRectangle(cornerRadius: 30)
                    
                    .frame(height: 100)
                    .background(.ultraThinMaterial,in: RoundedRectangle(cornerRadius: 30))
                    .opacity(0.1)
                
                HStack {
                    pdfModel.image?

                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .foregroundColor(.accentColor)
                        
                    Spacer()
                        .frame(width: 30)
                    Text(pdfModel.title ?? "" )
                    Spacer()
                }.padding()
            }
            
            
        
    }
}

