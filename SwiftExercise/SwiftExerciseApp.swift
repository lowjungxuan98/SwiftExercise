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
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
