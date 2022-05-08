//
//  CurrencyViewModel.swift
//  CurrencyApp
//
//  Created by Oleh Pazynich on 2022/04/13.
//

import Foundation
import SwiftUI

@MainActor class CurrencyViewModel : ObservableObject {
    private var currencyRepo = CurrencyRepository()
    
    @Published var quotesCurrentList: [QuoteCurrency] = []
    @Published var nameList: [String] = []
    @Published var baseCurrency: String = "USD"
    
    func getQuotesThroughUSD() {
        let quotesForUsdList = currencyRepo.quotesForUsdList
        getQuotesThroughUsdCalculation(quotesForUsdList: quotesForUsdList)
    }
     
    func getQuotesThroughUsdCalculation(quotesForUsdList: [QuoteCurrency]) {
        if let i = quotesForUsdList.firstIndex(where: { $0.name == baseCurrency }) {
            let baseToUSD = 1 / quotesForUsdList[i].quoteCurrency
            for i in 0...quotesCurrentList.count - 1 {
                quotesCurrentList[i].quoteCurrency = baseToUSD * quotesForUsdList[i].quoteCurrency
            }
        }
    }
    
    func amountCalculation(amount: String, quoteCurrency: Double) -> Double {
        return quoteCurrency * abs(Double(amount) ?? 1)
    }
    
    func getQuotes() async {
        await currencyRepo.getQuotes()
        quotesCurrentList = currencyRepo.quotesForUsdList
        nameList = quotesCurrentList.map { $0.name }
    }
}
