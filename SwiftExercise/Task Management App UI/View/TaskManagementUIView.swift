//
//  TaskManagementUIView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 21/11/2022.
//

import SwiftUI

struct TaskManagementUIView: View {
    @StateObject var taskModel: TaskUIViewModel = .init()
    @Namespace var animation
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            // MARK: Laszy Stack with pinned header

            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    // MARK: Current week view

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(taskModel.currentWeek, id: \.self) { day in
                                VStack(spacing: 10) {
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    // EEE will return day as MON,TUE,... etc
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .secondary)
                                .foregroundColor(taskModel.isToday(date: day) ? .white : .black)

                                // MARK: Capsule shape

                                .frame(width: 45, height: 90)
                                .background {
                                    ZStack {
                                        // MARK: Matched geometry effect

                                        if taskModel.isToday(date: day) {
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                }
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation {
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    TasksView()
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }

    // MARK: Tasks View

    @ViewBuilder
    func TasksView()->some View {
        LazyVStack(spacing: 20) {
            if let tasks = taskModel.filteredTasks {
                if tasks.isEmpty {
                    Text("No tasks found!!!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                } else {
                    ForEach(tasks) {
                        TaskCardView($0)
                    }
                }
            } else {
                // MARK: Progress View

                ProgressView()
                    .offset(y: 100)
            }
        }
        .padding()
        .padding(.top)

        // MARK: Updating tasks

        .onChange(of: self.taskModel.currentDay) { _ in
            taskModel.filterTodayTasks()
        }
    }

    // MARK: Task Card View

    @ViewBuilder
    func TaskCardView(_ task: TaskUI)->some View {
        HStack(alignment: .top, spacing: 30) {
            VStack(spacing: 10) {
                Circle()
                    .fill(taskModel.isCurrentHour(task.taskDate) ? .black : .clear)
                    .frame(width: 15, height: 15)
                    .background {
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .padding(-3)
                    }
                    .scaleEffect(!taskModel.isCurrentHour(task.taskDate) ? 0.8 : 1)
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }

            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle)
                            .font(.title2.bold())
                        Text(task.taskDescription)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }

                if taskModel.isCurrentHour(task.taskDate) {
                    // MARK: Team Members

                    HStack(spacing: 0) {
                        HStack(spacing: -10) {
                            ForEach(["User1", "User2", "User3"], id: \.self) { user in
                                Image(user)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .background {
                                        Circle()
                                            .stroke(.black, lineWidth: 5)
                                    }
                            }
                        }
                        .hLeading()

                        // MARK: Check Button

                        Button {} label: {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black)
                                .padding(10)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.top)
                }
            }
            .foregroundColor(taskModel.isCurrentHour(task.taskDate) ? .white : .black)
            .padding(taskModel.isCurrentHour(task.taskDate) ? 15 : 0)
            .padding(.bottom, taskModel.isCurrentHour(task.taskDate) ? 0 : 10)
            .hLeading()
            .background {
                Color("Black")
                    .cornerRadius(25)
                    .opacity(taskModel.isCurrentHour(task.taskDate) ? 1 : 0)
            }
        }
        .hLeading()
    }

    // MARK: Header

    @ViewBuilder
    func HeaderView()->some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                Text("Today")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            Button {} label: {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color.white)
    }
}

struct TaskManagementUIView_Previews: PreviewProvider {
    static var previews: some View {
        TaskManagementUIView()
    }
}

// MARK: UI Design Helper functions

extension View {
    func hLeading()->some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func hTrailing()->some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }

    func hCenter()->some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }

    // MARK: Safe Area

    func getSafeArea()->UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }

        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        return safeArea
    }
}
