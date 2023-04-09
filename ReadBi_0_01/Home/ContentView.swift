import PDFKit
import SwiftUI
import UIKit

struct PDFViewer: UIViewControllerRepresentable {
    @Binding var url: URL?

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = PDFInsideViewController(pdfUrl: $url)
        url?.startAccessingSecurityScopedResource()

        if let url = url {
            vc.pdfView.document = PDFDocument(url: url)
            vc.pdfView.delegate = context.coordinator
        }

        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

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

class CustomPDFViewer: PDFView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
}

struct ContentView: View {
    @State private var isPickerPresented = false
    @State private var pdfUrl: URL? = nil
    @ObservedObject var translatedTextVM = TranslateTextViewModel()
    @ObservedObject var PDFOveriviewVM = PDFOverviewViewModel()

    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                if let pdfUrl = pdfUrl {
                    PDFViewer(url: $pdfUrl)
                        .ignoresSafeArea()
                        .onAppear {
                            print(pdfUrl)
                        }.transition(.move(edge: .bottom))

                    if ((translatedTextVM.selectedString) != nil) {
                        TranslationView().environmentObject(translatedTextVM)
                    }
                } else {
                    VStack {
                        
                        if (PDFOveriviewVM.PDFs.count == 0) {
                            VStack {
                                Spacer()
                                NoPDFPlaceholder()
                                Spacer()
                            }.frame(height: UIScreen.main.bounds.height)
                        }
                        PDFList(pdfUrl: $pdfUrl, PDFOveriviewVM: PDFOveriviewVM)
                    }
                }
            }
            
            
            .toolbar {
                if (pdfUrl == nil) {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isPickerPresented = true
                        }) {
                            Image(systemName: "plus")
                                
                        }
                        .sheet(isPresented: $isPickerPresented) {
                            DocumentPicker { url in
                                PDFOveriviewVM.addPDF(url: url)
                                isPickerPresented = false
                            }
                        }
                    }
                }
            }
        }
    }
}


struct NoPDFPlaceholder: View {
    @State private var imageOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                ZStack(alignment: .center) {
                    Image("placeholder_keddy")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .opacity(0.6)

                    Image("placeholder_keddy")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .offset(y: imageOffset)
                        .animation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true))
                }
                .onAppear {
                    imageOffset = -20
                }

                Text("You didn't select any PDF.")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}
struct PDFList: View {
    @Binding var pdfUrl: URL?
    @ObservedObject var PDFOveriviewVM: PDFOverviewViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(PDFOveriviewVM.PDFs, id: \.id) { pdfModel in
                    Button(action: {
                        withAnimation(.easeInOut) {
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


