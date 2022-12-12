//
//  DockAttributes.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/12/2022.
//

import ActivityKit
import Foundation
import SwiftUI

struct DockAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {}

    // Fixed non-changing properties about your activity go here!
    var name: String
    // We don't need any Live updates here, so ContentState will be empty
    var addedLinks: [AppLink]
}
