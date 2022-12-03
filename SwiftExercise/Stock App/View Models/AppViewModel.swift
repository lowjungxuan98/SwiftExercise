//
//  AppViewModel.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 04/12/2022.
//

import _Concurrency
import Foundation
import StocksAPI
import SwiftUI

@MainActor
class AppViewModel: ObservableObject {
    @Published var tickers: [Ticker] = [] {
        didSet { saveTickers() }
    }

    @Published var selectedTicker: Ticker?
    
    var titleText = "Zack Stocks"
    
    @Published var subtitleText: String
    
    var emptyTickersText = "Search & add symbol to see stock quotes"
    
    var attributionText = "Powered by Yahoo! finance API"
    
    private let subtitleDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d MMM"
        return df
    }()

    let tickerListRepository: TickerListRepository
    init(repository: TickerListRepository = TickerPlistRepository()) {
        self.tickerListRepository = repository
        self.subtitleText = subtitleDateFormatter.string(from: Date())
    }
    
    private func loadTickers() {
        _Concurrency.Task {
            do {
                tickers = try await tickerListRepository.load()
            } catch {
                print(error.localizedDescription)
                tickers = []
            }
        }
    }
    
    private func saveTickers() {
        _Concurrency.Task {
            do {
                try await tickerListRepository.save(tickers)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeTickers(atOffsets offsets: IndexSet) {
        tickers.remove(atOffsets: offsets)
    }
    
    func isAddedToMyTickers(ticker: Ticker) -> Bool {
        tickers.first { item in
            item.symbol == ticker.symbol
        } != nil
    }
    
    func toggleTicker(_ ticker: Ticker) {
        if isAddedToMyTickers(ticker: ticker) {
            removeFromMyTickers(ticker: ticker)
        } else {
            addToMyTickers(ticker: ticker)
        }
    }
    
    private func addToMyTickers(ticker: Ticker) {
        tickers.append(ticker)
    }
    
    private func removeFromMyTickers(ticker: Ticker) {
        guard let index = tickers.firstIndex(where: { item in
            item.symbol == ticker.symbol
        }) else { return }
        tickers.remove(at: index)
    }
    
    func openYahooFinance() {
        let url = URL(string: "https://finance.yahoo.com")!
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
