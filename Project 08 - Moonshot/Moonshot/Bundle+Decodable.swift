//
//  Bundle+Decodable.swift
//  Moonshot
//
//  Created by Massimo Omodei on 10.11.20.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }

        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)

        guard let decoded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(T.self) from \(file)")
        }

        return decoded
    }
}
