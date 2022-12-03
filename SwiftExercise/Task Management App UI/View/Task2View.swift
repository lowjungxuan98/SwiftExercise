//
//  TaskManagementUIView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 21/11/2022.
//

import SwiftUI

struct Task2View: View {
    @StateObject var taskModel: Task2ViewModel = .init()
    @Namespace var animation
    @Environment(\.dismiss) var dismiss
    // MARK: Core Data Context
    @Environment(\.managedObjectContext) var context
    @Environment(\.editMode) var editButton
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

        // MARK: Add button

        .overlay(
            Button(
                action: {
                    taskModel.addNewTask.toggle()
                },
                label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black, in: Circle())
                })
            .padding(),
            alignment: .bottomTrailing)
     
        .sheet(isPresented: $taskModel.addNewTask) {
            taskModel.editTask = nil
        } content: {
            Task2Add()
                .environmentObject(taskModel)
        }

    }

    // MARK: Tasks View

    @ViewBuilder
    func TasksView()->some View {
        LazyVStack(spacing: 20) {
            Task2Filter(dateToFilter: taskModel.currentDay) { (object: Task2) in
                TaskCardView(object)
            }
        }
        .padding()
        .padding(.top)
    }

    // MARK: Task Card View

    @ViewBuilder
    func TaskCardView(_ task: Task2)->some View {
        HStack(alignment: editButton?.wrappedValue == .active ? .center : .top, spacing: 30) {
            if editButton?.wrappedValue == .active {
                VStack(spacing: 10) {
                    if task.taskDate?.compare(Date()) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? Date()) {
                        Button {
                            taskModel.addNewTask.toggle()
                            taskModel.editTask = task
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                    }
                    Button {
                        context.delete(task)
                        try? context.save()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
            }else{
                VStack(spacing: 10) {
                    Circle()
                        .fill(taskModel.isCurrentHour(task.taskDate ?? Date()) ? (task.isCompleted ? .green : .black) : .clear)
                        .frame(width: 15, height: 15)
                        .background {
                            Circle()
                                .stroke(.black, lineWidth: 1)
                                .padding(-3)
                        }
                        .scaleEffect(!taskModel.isCurrentHour(task.taskDate ?? Date()) ? 0.8 : 1)
                    Rectangle()
                        .fill(.black)
                        .frame(width: 3)
                }

            }
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                        Text(task.taskDescription ?? "")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    Text(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")
                }

                if taskModel.isCurrentHour(task.taskDate ?? Date()) {
                    // MARK: Team Members

                    HStack(spacing: 12) {
                       // MARK: Check Button
                        if !task.isCompleted{
                            Button {
                                task.isCompleted = true
                                try? context.save()
                            } label: {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.black)
                                    .padding(10)
                                    .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
                        Text(task.isCompleted ? "Marked as Completed" : "Mark Task as Completed")
                            .font(.system(size: task.isCompleted ? 14 : 16,weight: .light))
                            .foregroundColor(task.isCompleted ? .gray : .white)
                            .hLeading()
                    }
                    .padding(.top)
                }
            }
            .foregroundColor(taskModel.isCurrentHour(task.taskDate ?? Date()) ? .white : .black)
            .padding(taskModel.isCurrentHour(task.taskDate ?? Date()) ? 15 : 0)
            .padding(.bottom, taskModel.isCurrentHour(task.taskDate ?? Date()) ? 0 : 10)
            .hLeading()
            .background {
                Color("Black")
                    .cornerRadius(25)
                    .opacity(taskModel.isCurrentHour(task.taskDate ?? Date()) ? 1 : 0)
            }
        }
        .hLeading()
    }

    // MARK: Header

    @ViewBuilder
    func HeaderView()->some View {
        HStack(alignment: .top) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                Text("Today")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            EditButton()
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color.white)
    }
}

struct Task2View_Previews: PreviewProvider {
    static var previews: some View {
        Task2View()
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
