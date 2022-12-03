//
//  MockStocksAPI.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 04/12/2022.
//

import Foundation
import StocksAPI

#if DEBUG
struct MockStocksAPI: ZackStocksAPI {
    var stubbedSearchTickersCallback: (() async throws -> [Ticker])!
    func searchTickers(query: String, isEquityTypeOnly: Bool) async throws -> [Ticker] {
        try await stubbedSearchTickersCallback()
    }

    var stubbedFetchQuotesCallback: (() async throws -> [Quote])!
    func fetchQuotes(symbols: String) async throws -> [Quote] {
        try await stubbedFetchQuotesCallback()
    }

    var stubbedFetchChartDataCallback: ((ChartRange) async throws -> ChartData?)! = { $0.stubs }
    func fetchChartData(tickerSymbol: String, range: ChartRange) async throws -> ChartData? {
        try await stubbedFetchChartDataCallback(range)
    }
}
#endif
