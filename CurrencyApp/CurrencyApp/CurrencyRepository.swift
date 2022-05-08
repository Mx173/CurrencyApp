//
//  CurrencyRepository.swift
//  CurrencyApp
//
//  Created by Oleh Pazynich on 2022/04/15.
//

import Foundation

@MainActor class CurrencyRepository : ObservableObject {
    private var currencyService = CurrencyService()
    private let saveListPath = FileManager.documentsDirectory.appendingPathComponent("SavedQuotesForUsdList")
    private let saveTimePath = FileManager.documentsDirectory.appendingPathComponent("SavedLastUpdateTime")
    private let updatePeriod: Double = 1800 // 30mins
    
    private var lastUpdateTime: Date
    @Published private(set) var quotesForUsdList: [QuoteCurrency]
    
    init() {
        do {
            let data = try Data(contentsOf: saveListPath)
            let timeData = try Data(contentsOf: saveTimePath)
            lastUpdateTime = try JSONDecoder().decode(Date.self, from: timeData)
            quotesForUsdList = try JSONDecoder().decode([QuoteCurrency].self, from: data)
        } catch {
            lastUpdateTime = Date.distantPast
            quotesForUsdList = []
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(quotesForUsdList)
            let timeData = try JSONEncoder().encode(lastUpdateTime)
            try data.write(to: saveListPath, options: [.atomic, .completeFileProtection])
            try timeData.write(to: saveTimePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func getQuotes() async {
        if lastUpdateTime.addingTimeInterval(updatePeriod) < Date.now {
            await currencyService.getQuotesRequest()
            quotesForUsdList = currencyService.quotesForUsdList.sorted { $0.name < $1.name }
            lastUpdateTime = Date.now
            save()
        }
    }
}
