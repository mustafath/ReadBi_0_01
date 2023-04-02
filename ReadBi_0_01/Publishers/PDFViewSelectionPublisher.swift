import Combine
import PDFKit

class PDFViewSelectionPublisher: Publisher {
    typealias Output = String
    typealias Failure = Never
    
    private let pdfView: PDFView
    
    init(pdfView: PDFView) {
        self.pdfView = pdfView
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, String == S.Input {
        let subscription = PDFViewSelectionSubscription(subscriber: subscriber, pdfView: pdfView)
        subscriber.receive(subscription: subscription)
    }
}

private final class PDFViewSelectionSubscription<S: Subscriber>: Subscription where S.Input == String, S.Failure == Never {
    private var subscriber: S?
    private let pdfView: PDFView
    
    init(subscriber: S, pdfView: PDFView) {
        self.subscriber = subscriber
        self.pdfView = pdfView
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectionChanged), name: .PDFViewSelectionChanged, object: pdfView)
    }
    
    func request(_ demand: Subscribers.Demand) {
        // No-op, we only produce events on selection changes
    }
    
    func cancel() {
        subscriber = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func selectionChanged() {
        if let selection = pdfView.currentSelection?.string {
            _ = subscriber?.receive(selection)
        }
    }
}
