//
//  Models.swift
//  CurrencyApp
//
//  Created by Oleh Pazynich on 2022/04/14.
//

import Foundation

struct QuotesResponce: Codable {
    var quotes: [String: Double]
    var timestamp: Int
    var source: String
    var success: Bool
}

struct QuoteCurrency: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var quoteCurrency: Double
    var name: String
}
