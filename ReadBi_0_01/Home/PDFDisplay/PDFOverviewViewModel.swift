import Foundation
import SwiftUI
import PDFKit

class PDFOverviewViewModel: ObservableObject {
    @Published var PDFs: [PDFModel] = []

    public func addPDF(url: URL) {
        let title = getTitleFromPDF(at: url) ?? url.deletingPathExtension().lastPathComponent
        let image = generateThumbnailForPDF(at: url, size: CGSize(width: 40, height: 40)) ?? Image("defaultImage") // Replace "defaultImage"

        let model = PDFModel(title: title, url: url, image: image)
        self.PDFs.append(model)
        print(PDFs)
    }

    private func getTitleFromPDF(at url: URL) -> String? {
        url.startAccessingSecurityScopedResource()
        guard let pdfDocument = PDFDocument(url: url) else { return nil }

        if let title = pdfDocument.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String {
            return title
        } else {
            return nil
        }
    }

    private func generateThumbnailForPDF(at url: URL, size: CGSize) -> Image? {
        print("🔥Attempting to create PDFDocument for URL: \(url)")
        url.startAccessingSecurityScopedResource()
        guard let pdfDocument = PDFDocument(url: url) else {
            print("Failed to create PDFDocument for \(url)")
            return nil
        }
        guard let pdfPage = pdfDocument.page(at: 0) else {
            print("Failed to get first page of PDFDocument for \(url)")
            return nil
        }
        guard let cgPdfPage = pdfPage.pageRef else {
            print("Failed to get CGPDFPage for \(url)")
            return nil
        }

        let pdfPageRect = pdfPage.bounds(for: .mediaBox)
        let scale = min(size.width / pdfPageRect.width, size.height / pdfPageRect.height)

        let scaledSize = CGSize(width: pdfPageRect.width * scale, height: pdfPageRect.height * scale)
        let scaledRect = CGRect(origin: .zero, size: scaledSize)

        UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }

        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.white.cgColor)
            context.fill(scaledRect)

            context.saveGState()
            context.translateBy(x: 0, y: scaledSize.height)
            context.scaleBy(x: 1, y: -1)
            context.concatenate(cgPdfPage.getDrawingTransform(.mediaBox, rect: scaledRect, rotate: 0, preserveAspectRatio: true))
            context.drawPDFPage(cgPdfPage)
            context.restoreGState()

            if let cgImage = context.makeImage() {
                return Image(uiImage: UIImage(cgImage: cgImage))
            } else {
                print("Failed to generate thumbnail image for \(url)")
            }
        } else {
            print("Failed to get graphics context for \(url)")
        }

        return nil
    }

}
