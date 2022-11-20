//
//  DynamicFilteredView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 20/11/2022.
//

import CoreData
import SwiftUI

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject {
    // MARK: Core Data Request

    @FetchRequest var request: FetchedResults<T>
    let content: (T) -> Content

    // MARK: Building Custom ForEach which will give CoreData object to build view

    init(currentTab: String, @ViewBuilder content: @escaping (T) -> Content) {
        // MARK: Predicate to Filter current date Tasks

        let calendar = Calendar.current
        var predicate: NSPredicate!
        if currentTab == "Today" {
            let today = calendar.startOfDay(for: Date())
            let tommorow = calendar.date(byAdding: .day, value: 1, to: today)!

            // MARK: Filter Key

            let filterKey = "deadline"

            // MARK: this will fetch task between today and tommorow which is 24 HRS

            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tommorow, 0])
        } else if currentTab == "Upcoming" {
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tommorow = Date.distantFuture

            // MARK: Filter Key

            let filterKey = "deadline"

            // MARK: this will fetch task between today and tommorow which is 24 HRS

            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tommorow, 0])
        } else if currentTab == "Failed"{
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast

            // MARK: Filter Key

            let filterKey = "deadline"

            // MARK: this will fetch task between today and tommorow which is 24 HRS

            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [past, today, 0])
        }else{
            predicate = NSPredicate(format: "isCompleted == %i", argumentArray: [1])
        }

        //  MARK: Intializing Request With NSPredicate

        //  MARK: Adding Sort

        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }

    var body: some View {
        Group {
            if request.isEmpty {
                Text("No tasks found!!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID) { object in
                    self.content(object)
                }
            }
        }
    }
}
