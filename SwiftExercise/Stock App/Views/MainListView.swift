//
//  MainListView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 04/12/2022.
//
import StocksAPI
import SwiftUI

struct MainListView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appVM: AppViewModel
    @StateObject var quotesVM = QuotesViewModel()
    @StateObject var searchVM = SearchViewModel()
    var body: some View {
        tickerListView
            .listStyle(.plain)
            .overlay {
                overlayView
            }
            .toolbar {
                titleToolbar
                attributionToolbar
            }
            .searchable(text: $searchVM.query)
            .refreshable {
                await quotesVM.fetchQuotes(tickers: appVM.tickers)
            }
            .sheet(item: $appVM.selectedTicker, content: { item in
                StockTickerView(
                    chartVM: ChartViewModel(ticker: item, apiService: quotesVM.stocksAPI),
                    quoteVM: .init(ticker: item, stocksAPI: quotesVM.stocksAPI)
                )
                .presentationDetents([.height(560)])
            })
            .task(id: appVM.tickers) {
                await quotesVM.fetchQuotes(tickers: appVM.tickers)
            }
    }

    private var tickerListView: some View {
        List {
            ForEach(appVM.tickers) { ticker in
                TickerListRowView(data: .init(symbol: ticker.symbol, name: ticker.shortname, price: quotesVM.priceForTicker(ticker), type: .main))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        appVM.selectedTicker = ticker
                    }
            }
            .onDelete { appVM.removeTickers(atOffsets: $0) }
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        if appVM.tickers.isEmpty {
            EmptyStateView(text: appVM.emptyTickersText)
        }

        if searchVM.isSearching {
            SearchView(searchVM: searchVM)
        }
    }

    private var titleToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            HStack(alignment:.top) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: -4) {
                    Text(appVM.titleText)
                    Text(appVM.subtitleText)
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
                .font(.title2.weight(.heavy))
                .padding(.bottom)
            }
        }
    }

    private var attributionToolbar: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button {
                    appVM.openYahooFinance()
                } label: {
                    Text(appVM.attributionText)
                        .font(.caption.weight(.heavy))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
                .buttonStyle(.plain)
                Spacer()
            }
        }
    }
}

struct MainListView_Previews: PreviewProvider {
    @StateObject static var appVM: AppViewModel = {
        let vm = AppViewModel()
        vm.tickers = Ticker.stubs
        return vm
    }()

    @StateObject static var emptyAppVM: AppViewModel = {
        let vm = AppViewModel()
        vm.tickers = []
        return vm
    }()

    @StateObject static var quoteVM: QuotesViewModel = {
        let vm = QuotesViewModel()
        vm.quotesDict = Quote.stubsDict
        return vm
    }()

    @StateObject static var searchVM: SearchViewModel = {
        let vm = SearchViewModel()
        vm.phase = .success(Ticker.stubs)
        return vm
    }()

    static var previews: some View {
        Group {
            NavigationStack {
                MainListView(quotesVM: quoteVM, searchVM: searchVM)
            }
            .environmentObject(appVM)
            .previewDisplayName("With Tickers")

            NavigationStack {
                MainListView(quotesVM: quoteVM, searchVM: searchVM)
            }
            .environmentObject(appVM)
            .previewDisplayName("With Empty Tickers")
        }
    }
}
