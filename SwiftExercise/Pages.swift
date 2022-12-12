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
    case task_management_ui
    case flight_app
    case magnification_app
    case scrollable_header
    case stock_app
    case social_media_app
    case lock_screen_dock
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
        case .task_management_ui:
            return "Task Management App UI"
        case .flight_app:
            return "Flight App"
        case .magnification_app:
            return "Magnification App"
        case .scrollable_header:
            return "Scrollable Header"
        case .stock_app:
            return "Stock App"
        case .social_media_app:
            return "Social Media App"
        case .lock_screen_dock:
            return "Lock Screen Dock"
        }
    }
}
