//
//  LockScreenDock.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/12/2022.
//

import SwiftUI

struct LockScreenDock: View {
    var body: some View {
        NavigationStack {
            LockScreenDockHome()
                .navigationTitle("Lockscreen Dock")
        }
    }
}

struct LockScreenDock_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenDock()
    }
}
