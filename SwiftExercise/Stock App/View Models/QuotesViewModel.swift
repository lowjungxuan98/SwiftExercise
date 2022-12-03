//
//  QuotesViewModel.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 04/12/2022.
//

import Foundation
import StocksAPI
import SwiftUI

@MainActor
class QuotesViewModel: ObservableObject {
    @Published
    var quotesDict: [String?: Quote] = [:]
    
     let stocksAPI: ZackStocksAPI
    
    init(stocksAPI: ZackStocksAPI = StocksAPI()) {
        self.stocksAPI = stocksAPI
    }
    
    func fetchQuotes(tickers: [Ticker]) async {
        guard !tickers.isEmpty else { return }
        do {
            let symbols = tickers.map { $0.symbol }.joined(separator: ",")
            let quotes = try await stocksAPI.fetchQuotes(symbols: symbols)
            var dict = [String: Quote]()
            quotes.forEach { item in
                dict[item.symbol] = item
            }
            self.quotesDict = dict
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func priceForTicker(_ ticker: Ticker) -> PriceChange? {
        guard let quote = quotesDict[ticker.symbol],
              let price = quote.regularPriceText,
              let change = quote.regularDiffText
        else { return nil }
        return (price, change)
    }
}
