//
//  TaskManagementDynamicFilteredView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 22/11/2022.
//

import CoreData
import SwiftUI

struct Task2Filter<Content: View, T>: View where T: NSManagedObject {
    // MARK: Core Data Request

    @FetchRequest var request: FetchedResults<T>
    let content: (T) -> Content

    // MARK: Building Custom ForEach which will give CoreData object to build view

    init(dateToFilter: Date, @ViewBuilder content: @escaping (T) -> Content) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: dateToFilter)
        let tommorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let filterKey = "taskDate"
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today,tommorrow])
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task2.taskDate, ascending: false)], predicate: predicate)
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
