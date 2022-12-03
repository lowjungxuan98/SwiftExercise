//
//  StockApp.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 03/12/2022.
//

import SwiftUI

struct StockApp: View {
    @StateObject var appVM = AppViewModel()
    var body: some View {
        NavigationStack {
            MainListView()
        }
        .environmentObject(appVM)
    }
}

struct StockApp_Previews: PreviewProvider {
    static var previews: some View {
        StockApp()
    }
}
