//
//  CameraView.swift
//  CardKeeper
//
//  Created by Tim Coder on 6/2/24.
//

import Foundation
import SwiftUI

enum SourceType: Identifiable {
    var id: Self { self }
    case photoLibrary, camera
}

struct CameraView: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .camera
    @Binding var imageData: Data?
    var completion: (Data?)->()
    
    @Environment(\.presentationMode) private var presentationMode
    
    init(sourceType: SourceType, imageData: Binding<Data?>, completion: @escaping (Data?)->() = {_ in}) {
        switch sourceType {
            
        case .photoLibrary:
            self.sourceType = .photoLibrary
        case .camera:
            self.sourceType = .camera
        }
        self._imageData = imageData
        self.completion = completion
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraView>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraView
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let data = image.pngData()
                parent.imageData = data
            }
            parent.completion(parent.imageData)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
