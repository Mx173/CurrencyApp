//
//  CurrencyService.swift
//  CurrencyApp
//
//  Created by Oleh Pazynich on 2022/04/14.
//

import Foundation

@MainActor class CurrencyService : ObservableObject {
    private let urlRequest = "http://api.currencylayer.com/live?access_key=5399b329496cc825966ad957415cc858"
    @Published var quotesForUsdList: [QuoteCurrency] = []
    
    func getQuotesRequest() async {
        guard let url = URL(string: urlRequest) else {
            print("Invalid url")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(QuotesResponce.self, from: data) {
                quotesForUsdList = decodedResponse.quotes.compactMap({ (key: String, value: Double) -> QuoteCurrency? in
                    return QuoteCurrency(quoteCurrency: value, name: String(key.dropFirst(3)))
               })
           }
        } catch {
            print("Error request")
        }
    }
}
