//
//  CurrencyAppTests.swift
//  CurrencyAppTests
//
//  Created by Oleh Pazynich on 2022/04/11.
//

import XCTest
@testable import CurrencyApp

class CurrencyAppTests: XCTestCase {
    
    //test cases for 0, 1, 2, many, floated point number, negative number, not number at all and empty field(that counts as "1")
    @MainActor func testVmAmountCalculation() throws {
        let vm = CurrencyViewModel()
        
        XCTAssertEqual(0.0, vm.amountCalculation(amount: "0", quoteCurrency: 10.5))
        XCTAssertEqual(10.5, vm.amountCalculation(amount: "1", quoteCurrency: 10.5))
        XCTAssertEqual(21.0, vm.amountCalculation(amount: "2", quoteCurrency: 10.5))
        XCTAssertEqual(1575.0, vm.amountCalculation(amount: "150", quoteCurrency: 10.5))
        XCTAssertEqual(16.065, vm.amountCalculation(amount: "1.53", quoteCurrency: 10.5))
        XCTAssertEqual(10.5, vm.amountCalculation(amount: "-1", quoteCurrency: 10.5))
        XCTAssertEqual(10.5, vm.amountCalculation(amount: "asfasg24", quoteCurrency: 10.5))
        XCTAssertEqual(10.5, vm.amountCalculation(amount: "", quoteCurrency: 10.5))
    }
    
    @MainActor func testGetQuotesThroughUsdCalculation() throws {
        let quoteJPY = QuoteCurrency(id: "1", quoteCurrency: 100.0, name: "JPY")
        let quoteUAH = QuoteCurrency(id: "2", quoteCurrency: 25.0, name: "UAH")
        let quoteUSD = QuoteCurrency(id: "3", quoteCurrency: 1.0, name: "USD")
        let quotesForUsdList: [QuoteCurrency] = [quoteJPY, quoteUAH, quoteUSD]
        
        let vm = CurrencyViewModel()
        vm.quotesCurrentList = quotesForUsdList
        
        vm.baseCurrency = "UAH"
        vm.getQuotesThroughUsdCalculation(quotesForUsdList: quotesForUsdList)
        
        let resultQuoteJPY = QuoteCurrency(id: "1", quoteCurrency: 4.0, name: "JPY")
        let resultQuoteUAH = QuoteCurrency(id: "2", quoteCurrency: 1.0, name: "UAH")
        let resultQuoteUSD = QuoteCurrency(id: "3", quoteCurrency: 0.04, name: "USD")
        let resultList = [resultQuoteJPY, resultQuoteUAH, resultQuoteUSD]
        
        XCTAssertEqual(resultList, vm.quotesCurrentList)
    }
}
