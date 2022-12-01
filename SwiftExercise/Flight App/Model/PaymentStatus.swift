//
//  File.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 01/12/2022.
//

import Foundation
import SwiftUI

enum PaymentStatus:String,CaseIterable{
    case started = "Connected..."
    case initated = "Secure payment..."
    case finished = "Purchased..."
    
    var symbolImage:String{
        switch self {
        case .started:
            return "wifi"
        case .initated:
            return "checkmark.shield"
        case .finished:
            return "checkmark"
        }
    }
}
