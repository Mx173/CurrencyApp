//
//  FileManagerExtension.swift
//  CurrencyApp
//
//  Created by Oleh Pazynich on 2022/04/15.
//

import Foundation
extension FileManager {
    static var documentsDirectory: URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
    }
}
