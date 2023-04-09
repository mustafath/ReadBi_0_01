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
                        .frame(width: 80)
                        .foregroundColor(.accentColor)
                        .blur(radius: 40)
                    Spacer()
                        .frame(width: 30)
                    Text(pdfModel.title ?? "" )
                        .font(.caption)
                    Spacer()
                }.padding()
                    .frame(height: .infinity)
                
                RoundedRectangle(cornerRadius: 10)
                    
                    .frame(height: 125)
                    .opacity(0.1)
                    
                    .background(VisualEffectView(effect: UIBlurEffect(style: .light))
                        .cornerRadius(10))
                
                    .foregroundColor(.white)
                
                HStack {
                    pdfModel.image?

                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                        .foregroundColor(.accentColor)
                        
                    Spacer()
                        .frame(width: 30)
                    Text(pdfModel.title ?? "" )
                        .font(.caption)
                    Spacer()
                }.padding()
            }
            
            
        
    }
}



struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: effect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}
