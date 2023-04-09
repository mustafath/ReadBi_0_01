import UIKit
import PDFKit

import SwiftUI



class PDFInsideViewController: UIViewController, PDFViewDelegate {
    
    @Binding var pdfUrl: URL?
    
    init(pdfUrl: Binding<URL?>) {
        
        self._pdfUrl = pdfUrl
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    let pdfView = CustomPDFViewer()
    let slider = UISlider(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
    let blurredBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    
    let xmarkButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xmarkButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                xmarkButton.tintColor = .black
                xmarkButton.frame.size = CGSize(width: 30, height: 30)
                xmarkButton.translatesAutoresizingMaskIntoConstraints = false
        
        slider.addSubview(xmarkButton)
                
                // Position the xmarkButton relative to the slider using Auto Layout constraints
                NSLayoutConstraint.activate([
                    xmarkButton.topAnchor.constraint(equalTo: slider.topAnchor),
                    xmarkButton.leadingAnchor.constraint(equalTo: slider.leadingAnchor),
                    xmarkButton.widthAnchor.constraint(equalToConstant: 30),
                    xmarkButton.heightAnchor.constraint(equalToConstant: 30)
                ])
                
                // Add a target for the touchUpInside event
                xmarkButton.addTarget(self, action: #selector(xmarkButtonTapped), for: .touchUpInside)
                

        
        
        pdfView.autoScales = true
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.delegate = self
        
        
        slider.minimumValue = 0
        slider.maximumValue = Float(pdfView.document?.pageCount ?? 0) - 1.0
        slider.tintColor = UIColor(.black)
        slider.setThumbImage(UIImage(systemName: "star.fill"), for: .normal)
        
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        let onTapScreen = UITapGestureRecognizer(target: self, action: #selector(changeControllersVisibility))
        view.addGestureRecognizer(onTapScreen)
        
        let stackView = UIStackView(arrangedSubviews: [pdfView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        slider.heightAnchor.constraint(equalToConstant: 75).isActive = true
        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        
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
        }
    }
    
    @objc func xmarkButtonTapped() {
        withAnimation(.easeInOut){
            pdfUrl?.stopAccessingSecurityScopedResource()
            pdfUrl = nil
        }
        }
    
    @objc func changeControllersVisibility() {
        withAnimation(.easeInOut){
            slider.isHidden.toggle()
            blurredBackgroundView.isHidden.toggle()
        }
    }
    
    @objc func sliderValueChanged(sender: UISlider) {
        print(sender.value)
        pdfView.go(to: (pdfView.document?.page(at: Int(sender.value))!)!)
    }
}

