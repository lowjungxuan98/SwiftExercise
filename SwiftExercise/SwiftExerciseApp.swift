//
//  SwiftExerciseApp.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/11/2022.
//

import Firebase
import SwiftUI
@main
struct SwiftExerciseApp: App {
    init() {
        FirebaseApp.configure()
    }

    @StateObject var viewModel = StudentViewModel()
    let persistenceController = PersistenceController.shared
    @StateObject var appVM = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(appVM)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
