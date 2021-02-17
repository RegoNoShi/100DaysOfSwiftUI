//
//  Person+UIImage.swift
//  PeopleReminder
//
//  Created by Massimo Omodei on 16.02.21.
//

import UIKit

extension Person {
    private var imageUrl: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("images")
            .appendingPathComponent("\(id).jpg")
    }
    
    var image: UIImage? {
        guard let data = try? Data(contentsOf: imageUrl), let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    func saveImage(_ image: UIImage) throws {
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try jpegData.write(to: imageUrl, options: [.atomicWrite, .completeFileProtection])
        }
    }
}
