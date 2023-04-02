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

class PDFInsideViewController : UIViewController, PDFViewDelegate {
    let pdfView = CustomPDFViewer()
    let slider = UISlider(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400))
    let stackView = UIStackView()
    let blurredBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pdfView.autoScales = true
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.delegate = self
        slider.tintColor = UIColor(.black)
        slider.minimumValue = 0
        slider.maximumValue = Float(pdfView.document?.pageCount ?? 0) - 1.0
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        let onTapScreen = UITapGestureRecognizer(target: self, action: #selector(changeControllersVisibility))
        view.addGestureRecognizer(onTapScreen)
        
        let stackView = UIStackView(arrangedSubviews: [pdfView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        slider.heightAnchor.constraint(equalToConstant: 50).isActive = true
        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
        
        // Create a UIVisualEffectView with a blur effect
        
        blurredBackgroundView.layer.opacity = 0.8
        blurredBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurredBackgroundView, belowSubview: slider)
        
        NSLayoutConstraint.activate([
            blurredBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurredBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurredBackgroundView.topAnchor.constraint(equalTo: slider.topAnchor),
            blurredBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NotificationCenter.default.addObserver(
            forName: .PDFViewPageChanged, object: nil, queue: nil
        ) { notification in
            if let pdfView = notification.object as? PDFView {
                self.slider.setValue(Float(pdfView.currentPage?.pageRef?.pageNumber ?? 0), animated: true)
                
                
            }
            
        }}



    
    
    
    @objc func changeControllersVisibility() {
        slider.isHidden.toggle()
        blurredBackgroundView.isHidden.toggle()
    }
    
    
    @objc func sliderValueChanged(sender: UISlider) {
        print(sender.value)
        
        
        pdfView.go(to: (pdfView.document?.page(at: Int(sender.value))!)!)
        
        
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
    //    = URL(string: "file:///Users/mustafagirgin/Library/Developer/CoreSimulator/Devices/48472285-C91C-4F87-9205-13AC109D66B7/data/Containers/Shared/AppGroup/FA4F6C41-5A8D-4F23-B1F0-25A472CFB899/File%20Provider%20Storage/BLM2067Arasinav.pdf")
    @State private var selectedText: String?
    @ObservedObject var translatedTextVM = TranslateTextViewModel()

    
    @ObservedObject var PDFOveriviewVM = PDFOverviewViewModel()
    
    var body: some View {
        VStack {
            if let pdfUrl = pdfUrl {
                
                ZStack {
                    
                    PDFViewer(url: pdfUrl).onAppear {
                        
                        print(pdfUrl)
                    }.transition(.move(edge: .leading))
                    
                    
                    if ((translatedTextVM.selectedString) != nil) {
                        TranslationView().environmentObject(translatedTextVM)
                    }
                    
                    Image(systemName: "xmark")
                        .frame(width: 200, height: 200)
                        .background(Color.black)
                        
                        .foregroundColor(.red)
                        .onTapGesture {
                            
                            print("selam selam selam")
                            self.pdfUrl = nil
                        }
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
