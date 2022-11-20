//
//  TaskManagerView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 20/11/2022.
//

import SwiftUI

struct TaskManagerView: View {
    @StateObject var taskModel: TaskViewModel = .init()

    // MARK: Matched Geometry Namespace

    @Namespace var animation

    // MARK: Fetching Task

    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<Task>

    // MARK: Environment Values

    @Environment(\.self) var env

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome Back")
                        .font(.callout)
                    Text("Here's Update Today.")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)

                CustomSegmentedBar()
                    .padding(.top, 5)

                // MARK: Task View

                TaskView()
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            // MARK: Add Button

            Button {
                taskModel.openEditTask.toggle()
            } label: {
                Label {
                    Text("Add Task")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(.black, in: Capsule())
            }

            // MARK: Linear Gradient BG

            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background {
                LinearGradient(colors: [
                    .white.opacity(0.05),
                    .white.opacity(0.4),
                    .white.opacity(0.7)
                ], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            }
        }
        .fullScreenCover(isPresented: $taskModel.openEditTask) {
            taskModel.resetTaskData()
        } content: {
            AddNewTask()
                .environmentObject(taskModel)
        }
    }

    // MARK: Task View

    @ViewBuilder
    func TaskView() -> some View {
        LazyVStack(spacing: 20) {
            DynamicFilteredView(currentTab: taskModel.currentTab) { (task: Task) in
                TaskRowView(task)
            }
        }
    }

    // MARK: Task Row View

    @ViewBuilder
    func TaskRowView(_ task: Task) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(task.type ?? "")
                    .font(.callout)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background {
                        Capsule()
                            .fill(.gray.opacity(0.3))
                    }
                Spacer()

                // MARK: Edit Button Only for Non Completed Tasks

                if !task.isCompleted && taskModel.currentTab != "Failed" {
                    Button {
                        taskModel.editTask = task
                        taskModel.openEditTask = true
                        taskModel.setupTask()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }
                }
            }

            Text(task.title ?? "")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical, 10)

            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)

                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if !task.isCompleted && taskModel.currentTab != "Failed" {
                    Button {
                        // MARK: Update Core Data

                        task.isCompleted.toggle()
                        try? env.managedObjectContext.save()
                    } label: {
                        Circle()
                            .stroke(.black, lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Yellow"))
        }
    }

    // MARK: - Custom Segmented Bar

    @ViewBuilder
    func CustomSegmentedBar() -> some View {
        let tabs = ["Today", "Upcoming", "Task Done", "Failed"]
        HStack(spacing: 10) {
            ForEach(tabs, id: \.self) { tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(taskModel.currentTab == tab ? .white : .black)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background {
                        if taskModel.currentTab == tab {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            taskModel.currentTab = tab
                        }
                    }
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct TaskManagerView_Previews: PreviewProvider {
    static var previews: some View {
        TaskManagerView()
            .environmentObject(TaskViewModel())
    }
}
