//
//  TickerQuoteViewModel.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 04/12/2022.
//

import Foundation
import StocksAPI
import SwiftUI

@MainActor
class TickerQuoteViewModel: ObservableObject {
    @Published var phase = FetchPhase<Quote>.initial
    var quote: Quote? { phase.value}
    var error: Error? {phase.error}
    
    let ticker:Ticker
    let stocksAPI:ZackStocksAPI
    
    init(ticker:Ticker,stocksAPI: ZackStocksAPI = StocksAPI()){
        self.ticker = ticker
        self.stocksAPI = stocksAPI
    }
    
    func fetchQuote() async {
        phase = .fetching
        
        do {
            let response = try await stocksAPI.fetchQuotes(symbols: ticker.symbol)
            if let quote = response.first{
                phase = .success(quote)
            }else{
                phase = .empty
            }
        }catch{
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
}
