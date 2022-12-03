//
//  MockTickerListRepository.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 04/12/2022.
//

import Foundation
import StocksAPI
#if DEBUG
struct MockTickerListRepository: TickerListRepository {
    var stubbedLoad: (() async throws -> [Ticker])!
    func load() async throws -> [Ticker] {
        try await stubbedLoad()
    }

    func save(_ current: [Ticker]) async throws {}
}
#endif
