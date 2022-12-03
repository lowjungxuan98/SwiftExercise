//
//  SearchViewModel.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 04/12/2022.
//

import Combine
import Foundation
import StocksAPI
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var phase: FetchPhase<[Ticker]> = .initial
    
    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var tickers: [Ticker] { phase.value ?? [] }
    
    var error: Error? { phase.error }
    
    var isSearching: Bool { !trimmedQuery.isEmpty }
    
    var emptyListText: String {
        "Symbols not found for\n\"\(query)\""
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let stocksAPI: ZackStocksAPI
    
    init(query: String = "", stocksAPI: ZackStocksAPI = StocksAPI()) {
        self.query = query
        self.stocksAPI = stocksAPI
        startObserving()
    }

    private func startObserving() {
        $query
            .debounce(for: 0.25, scheduler: DispatchQueue.main)
            .sink { _ in
                _Concurrency.Task {
                    [weak self] in await self?.searchTickers()
                }
            }
            .store(in: &cancellables)
        
        $query
            .filter { item in
                item.isEmpty
            }
            .sink { [weak self] _ in
                self?.phase = .initial
            }
            .store(in: &cancellables)
    }

    func searchTickers() async {
        let searchQuery = trimmedQuery
        guard !searchQuery.isEmpty else { return }
        phase = .fetching
        
        do {
            let tickers = try await stocksAPI.searchTickers(query: searchQuery, isEquityTypeOnly: true)
            if searchQuery != trimmedQuery { return }
            if tickers.isEmpty {
                phase = .empty
            } else {
                phase = .success(tickers)
            }
        } catch {
            if searchQuery != trimmedQuery { return }
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
}
