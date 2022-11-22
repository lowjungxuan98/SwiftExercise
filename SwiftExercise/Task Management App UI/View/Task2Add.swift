//
//  NewTask.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 22/11/2022.
//

import SwiftUI

struct Task2Add: View {
    @Environment(\.dismiss) var dismiss
    
    // MARK: Task Value
    @State var taskTitle:String = ""
    @State var taskDescription:String = ""
    @State var taskDate:Date = Date()
    
    // MARK: Core Data Context
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var taskModel:Task2ViewModel
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Go to work", text: $taskTitle)
                } header: {
                    Text("Task Title")
                }
                Section {
                    TextField("Nothing", text: $taskDescription)
                } header: {
                    Text("Task Description")
                }
                if taskModel.editTask == nil {
                    Section {
                        DatePicker("", selection: $taskDate)
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                    } header: {
                        Text("Task Date")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            //MARK: Disabling Dismiss on Swipe
            .interactiveDismissDisabled()
            //MARK:Action Button
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save") {
                        if let task = taskModel.editTask {
                            task.taskTitle = taskTitle
                            task.taskDescription = taskDescription
                        } else {
                            let task = Task2(context: context)
                            task.taskTitle = taskTitle
                            task.taskDescription = taskDescription
                            task.taskDate = taskDate
                        }
                        
                        //MARK: Saving
                        try? context.save()
                        //MARK: Dismissing View
                        dismiss()
                    }
                    .disabled(taskTitle == "" || taskDescription == "")
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let task = taskModel.editTask{
                    taskTitle = task.taskTitle ?? ""
                    taskDescription = task.taskDescription ?? ""
                }
            }
        }
    }
}

struct Task2Add_Previews: PreviewProvider {
    static var previews: some View {
        Task2Add()
    }
}
