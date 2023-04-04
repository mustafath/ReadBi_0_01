import PDFKit
import SwiftUI
import UIKit






struct PDFViewer: UIViewControllerRepresentable {
    
  var url: URL
    

  func makeUIViewController(context: Context) -> UIViewController {
    
    let vc = PDFInsideViewController()
      url.startAccessingSecurityScopedResource()
    
      vc.pdfView.document = PDFDocument(url: url)
      vc.pdfView.delegate = context.coordinator
    
    return vc
  }

  
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, PDFViewDelegate {
    var parent: PDFViewer

    init(_ parent: PDFViewer) {
      self.parent = parent
    }
      
      


  }
}



import Foundation





import SwiftUI
import Combine




class CustomPDFViewer : PDFView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }


}

struct ContentView: View {
    
    @State private var isPickerPresented = false
    @State private var pdfUrl: URL?
    //    = URL(string: "file:///private/var/mobile/Library/Mobile%20Documents/com~apple~CloudDocs/Downloads/Robert%20Greene%20-%20I%CC%87ktidar.pdf")
//        = URL(string: "file:///Users/mustafagirgin/Library/Developer/CoreSimulator/Devices/48472285-C91C-4F87-9205-13AC109D66B7/data/Containers/Shared/AppGroup/FA4F6C41-5A8D-4F23-B1F0-25A472CFB899/File%20Provider%20Storage/BLM2067Arasinav.pdf")
    @State private var selectedText: String?
    @ObservedObject var translatedTextVM = TranslateTextViewModel()

    
    @ObservedObject var PDFOveriviewVM = PDFOverviewViewModel()
    
    var body: some View {
        VStack {
            if let pdfUrl = pdfUrl {
                
                ZStack {
                    
                    PDFViewer(url: pdfUrl)
                        .ignoresSafeArea()
                        .onAppear {
                        
                        print(pdfUrl)
                    }.transition(.move(edge: .leading))
                    
                    
                    if ((translatedTextVM.selectedString) != nil) {
                        TranslationView().environmentObject(translatedTextVM)
                    }
                    
//                    Image(systemName: "xmark")
//                        .frame(width: 200, height: 200)
//                        .background(Color.black)
//
//                        .foregroundColor(.red)
//                        .onTapGesture {
//
//                            print("selam selam selam")
//                            self.pdfUrl = nil
//                        }
                }
                
            } else {
                VStack {
                    Button(action: {
                        isPickerPresented = true
                    }) {
                        Text("Add PDF")
                            .font(.title)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $isPickerPresented) {
                        DocumentPicker { url in
                            PDFOveriviewVM.addPDF(url: url)
                            isPickerPresented = false
                        }
                    }
                    
                    
                    ScrollView {
                        VStack {
                            ForEach(PDFOveriviewVM.PDFs, id: \.id) { pdfModel in
                                
                                Button(action: {
                                    withAnimation(.easeInOut){
                                        self.pdfUrl = pdfModel.url
                                    }
                                }) {
                                    PDFOverviewView(pdfModel: pdfModel)
                                }.buttonStyle(.plain)
                            }
                        }
                    }.padding()
                    
                    
                    
                }
                
            }
        }
        
        
        
    }}
