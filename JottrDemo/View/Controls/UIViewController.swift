/*
 ActivityViewController.swift
 Jottr

 Created by Kenneth Gutierrez on 9/13/22.

 For wrapping a UIActivityViewController in SwiftUI View so we can gain access to UIKit’s classes
 code samples from https://swifttom.com/2020/02/06/how-to-share-content-in-your-app-using-uiactivityviewcontroller-in-swiftui/
 & https://www.hackingwithswift.com/books/ios-swiftui/wrapping-a-uiviewcontroller-in-a-swiftui-view
 */

import AuthenticationServices
import FLAnimatedImage
import MessageUI
import PhotosUI
import SwiftUI
import UIKit

// SwiftUI wrapper for UITextView
struct TextView: UIViewRepresentable {
    // property that stores the text string we are working with
    @Binding var text: NSMutableAttributedString
    
    // method that will return our text view
    func makeUIView(context: Context) -> UITextView {
        UITextView()
    }
    
    // method that will be called whenever the data for the text view has changed
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = text
    }
}

// sharing content in Jottr using a UIViewControllerRepresentable
struct ActivityViewController: UIViewControllerRepresentable {
    /*
     itemsToShare is for our content that we want to pass to other services and
     servicesToShareItem is to get a list of service we can uses to share our content
     */
    var itemsToShare: [Any]
    var servicesToShareItem: [UIActivity]? = nil
    
    // where we sent the context to UIActivityViewController so it can be displayed in SwiftUI
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: itemsToShare, applicationActivities: servicesToShareItem)
        
        return controller
    }
    
    // to keep the Controller up to date with any changes
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

// adding gif: https://blog.logrocket.com/adding-gifs-ios-app-flanimatedimage-swiftui/#swift-package-manager
struct GIFView: UIViewRepresentable {
    // a closure being an instance of FLAnimatedImageView
    private let imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    // the two required methods for this UIViewRepresentable that must be implemented
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        
        view.addSubview(imageView)
        
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // gif file must not be in assets, image saved in Resources File
        let path = Bundle.main.path(forResource: "darwin", ofType: "gif")!
        
        var data: Data!
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            debugPrint(error.localizedDescription)
        }
        let image = FLAnimatedImage(animatedGIFData: data)
        
        imageView.animatedImage = image
    }
}

// saving an image to the user's photo library
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    // a nested class for SwiftUI’s coordinators which are designed to act as delegates for UIKit view controllers.
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    /*
     We aren’t going to be using updateUIViewController(), so deleted the “code” line
     from there so that the method is empty.
     */
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    // the bridge between UIKit and SwiftUI, allowing both to communicate to each other
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /*
     A hack to make Xcode write the two methods we actually need, and in fact those two methods above
     are actually enough for Swift to figure out the view controller type so you can delete the typealias line.
     */
//    typealias UIViewControllerType = PHPickerViewController
}
