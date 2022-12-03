//
//  TickerListRowData.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 04/12/2022.
//

import Foundation

typealias PriceChange=(price:String,change:String)

struct TickerListRowData{
    enum RowType{
        case main
        case search(isSaved:Bool,onButtonTapped:()->())
    }
    
    let symbol:String
    let name:String?
    let price:PriceChange?
    let type:RowType
}
