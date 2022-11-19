//
//  Pages.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/11/2022.
//

import Foundation
import SwiftUI

let pages = [
    "Restful API",
    "Socket IO",
    "Animated Sticky Header"
]

enum Pages: Int, CaseIterable, Identifiable {
    case restApi
    case socketIO
    case animatedStickyHeader
    case parallaxCardEffect

    var id: Int { return rawValue }

    var label: String {
        switch self {
        case .restApi:
            return "Restful API"
        case .socketIO:
            return "Socket IO"
        case .animatedStickyHeader:
            return "Animated Sticky Header"
        case .parallaxCardEffect:
            return "3D Parallax Card Effect"
        }
    }
}
