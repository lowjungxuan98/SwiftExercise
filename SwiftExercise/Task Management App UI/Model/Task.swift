//
//  Task.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 21/11/2022.
//

import Foundation

// Task Model
struct TaskUI: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
