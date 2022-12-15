//
//  View+Extensions.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 15/12/2022.
//

import Foundation
import SwiftUI
// MARK: View Extensions For UI Building

extension View {
    // Closing All Active Keyboards
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    // MARK: View Extensions For UI Building

    func disableWithOpacity(_ condition: Bool)->some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }

    func hAlign(_ alignment: Alignment) ->some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }

    func vAlign(_ alignment: Alignment) ->some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }

    // MARK: Custom Border View with Padding

    func border(_ width: CGFloat, _ color: Color)->some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }

    // MARK: Custom Fill View with Padding

    func fillview(_ color: Color)->some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
}
