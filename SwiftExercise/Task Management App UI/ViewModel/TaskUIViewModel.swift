//
//  TaskUIViewModel.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 21/11/2022.
//

import SwiftUI
class TaskUIViewModel: ObservableObject {
    // Sample Tasks
    @Published var storedTasks: [TaskUI] = [
        TaskUI(taskTitle: "Meeting", taskDescription: "Discuss team task for the day", taskDate:
            .init(timeIntervalSince1970: 1669043279)),
        TaskUI(taskTitle: "Icon set", taskDescription: "Edit icons for team task for next week", taskDate: .init(timeIntervalSince1970: 1669041402)),
        TaskUI(taskTitle: "Prototype", taskDescription: "Make and send prototype", taskDate: .init(timeIntervalSince1970: 1669041402)),
        TaskUI(taskTitle: "Check asset", taskDescription: "Start checking the assets", taskDate:
            .init(timeIntervalSince1970: 1669041402)),
        TaskUI(taskTitle: "Team party", taskDescription: "Make fun with team mates", taskDate:
            .init(timeIntervalSince1970: 1669041426)),
        TaskUI(taskTitle: "Client Meeting", taskDescription: "Explain project to clinet", taskDate: .init(timeIntervalSince1970: 1669127790)),
        TaskUI(taskTitle: "Next Project", taskDescription: "Discuss next project with team", taskDate: .init(timeIntervalSince1970: 1669127790)),
        TaskUI(taskTitle: "App Proposal", taskDescription: "Meet client for next App Proposal", taskDate: .init(timeIntervalSince1970: 1669127790)),
    ]

    // MARK: Current Week Days

    @Published var currentWeek: [Date] = []

    // MARK: Current day

    @Published var currentDay: Date = .init()

    // MARK: Filtering Today tasks

    @Published var filteredTasks: [TaskUI]?

    // MARK: Initializing

    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }

    // MARK: Filter today task

    func filterTodayTasks() {
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            let filtered = self.storedTasks.filter {
                calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }
                .sorted { task1, task2 in
                    return task2.taskDate < task1.taskDate
                }

            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
        }
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
        return hour == currentHour
    }
}
