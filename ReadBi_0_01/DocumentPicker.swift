//
//  DocumentPicker.swift
//  ReadBi_0_01
//
//  Created by Mustafa Girgin on 28.03.2023.
//

import SwiftUI


struct DocumentPicker: UIViewControllerRepresentable {
  var onPick: (URL) -> Void

  func makeCoordinator() -> Coordinator {
    Coordinator(self)

  }

  func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
    let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
    documentPicker.delegate = context.coordinator
    return documentPicker
  }

  func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context)
  {
      
  }

  
}

class Coordinator: NSObject, UIDocumentPickerDelegate {
  var parent: DocumentPicker

  init(_ parent: DocumentPicker) {
    self.parent = parent
  }

  func documentPicker(
    _ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]
  ) {

    guard let url = urls.first else { return }
    parent.onPick(url)
  }
}

struct DocumentPicker_Previews: PreviewProvider {
    static var previews: some View {
        DocumentPicker { url in
            print("a")
        }
    }
}
