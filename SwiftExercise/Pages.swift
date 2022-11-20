//
//  Pages.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/11/2022.
//

import Foundation
import SwiftUI

enum Pages: Int, CaseIterable, Identifiable {
    case restApi
    case socketIO
    case animatedStickyHeader
    case parallaxCardEffect
    case core_data

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
        case .core_data:
            return "Task Manager (Core Data)"
        }
    }
}
