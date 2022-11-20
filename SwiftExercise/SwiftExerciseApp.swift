//
//  SwiftExerciseApp.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/11/2022.
//

import SwiftUI

@main
struct SwiftExerciseApp: App {
    @StateObject var viewModel = StudentViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
