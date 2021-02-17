//
//  ImagePickerView.swift
//  PeopleReminder
//
//  Created by Massimo Omodei on 16.02.21.
//

import UIKit
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    
    internal class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private let view: ImagePickerView
        
        init(_ view: ImagePickerView) {
            self.view = view
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                view.image = selectedImage
            }
            view.presentationMode.wrappedValue.dismiss()
        }
    }
}
