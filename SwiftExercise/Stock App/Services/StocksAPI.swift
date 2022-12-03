//
//  StocksAPI.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 04/12/2022.
//

import Foundation
import StocksAPI

protocol ZackStocksAPI {
    func searchTickers(query: String, isEquityTypeOnly: Bool) async throws -> [Ticker]
    func fetchQuotes(symbols: String) async throws -> [Quote]
    func fetchChartData(tickerSymbol: String, range: ChartRange) async throws -> ChartData?
}

extension StocksAPI: ZackStocksAPI {}
