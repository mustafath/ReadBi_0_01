import SwiftUI




struct TranslationView: View {
    @EnvironmentObject var translatedTextVM: TranslateTextViewModel
    
    var body: some View {
        VStack {
            if translatedTextVM.isTranslating == false {
                if translatedTextVM.selectedString != "" {
                    TranslatedTextView(text: translatedTextVM.selectedString, style: .completed)
                }
            } else if translatedTextVM.isTranslating == true {
                TranslatedTextView(style: .loading)
            }
        }
    }
}

struct TranslatedTextView: View {
    var text: String? = nil
    var style: TranslatedTextViewStyle
    
    var body: some View {
        switch style {
        case .completed:
            CompletedView(text: text)
        case .loading:
            LoadingView()
        }
    }
}

struct CompletedView: View {
    var text: String? = nil
    
    var body: some View {
        Text(text ?? "")
            .translatedTextStyle()
    }
}

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .translatedTextStyle()
    }
}

enum TranslatedTextViewStyle {
    case completed
    case loading
}
