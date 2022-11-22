//
//  TaskUIViewModel.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 21/11/2022.
//

import SwiftUI
class Task2ViewModel: ObservableObject {
    // MARK: Current Week Days

    @Published var currentWeek: [Date] = []

    // MARK: Current day

    @Published var currentDay: Date = .init()

    // MARK: Filtering Today tasks

    @Published var filteredTasks: [Task2]?
    // MARK: New Task View
    @Published var addNewTask: Bool = false
    
    //MARK: Edit Data
    @Published var editTask: Task2?

    // MARK: Initializing

    init() {
        fetchCurrentWeek()
    }

    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        guard let firstWeekDay = week?.start else {
            return
        }

        (1 ... 7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }

    // MARK: Extracting date

    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    // MARK: Checking if current date is today

    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }

    // MARK: Checking if the currentHour is task Hour

    func isCurrentHour(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        let isToday = calendar.isDateInToday(date)
        return (hour == currentHour && isToday)
    }
}
