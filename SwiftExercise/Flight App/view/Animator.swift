//
//  Animator.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 01/12/2022.
//

import Foundation
import SwiftUI

// MARK: ObserablableObject that hold all animation properties

class Animator: ObservableObject {
    @Published var startAnimation: Bool = false
    /// Initial Plane Position
    @Published var initialPlanePosition: CGRect = .zero
    @Published var currentPaymentStatus: PaymentStatus = .initated
    /// Rings Status
    @Published var ringAnimation: [Bool] = [false, false]
    /// Loading Status
    @Published var showLoadingView: Bool = false
    /// Cloud View Status
    @Published var showClouds: Bool = false
    /// Final View Status
    @Published var showFinalView: Bool = false
}

// MARK: Anchor Preference Key

struct RectKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
