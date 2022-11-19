//
//  StudentListView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/11/2022.
//

import SwiftUI

struct StudentListView: View {
    @EnvironmentObject var viewModel: StudentViewModel
    @State var showStudentDetail = false
    @State var firstName = ""
    @State var lastName = ""
    @State var rollNo = 0
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        List {
            ForEach(viewModel.items, id: \.id) { item in
                HStack {
                    Text(item.firstName)
                    Text(item.lastName)
                }
            }
        }
        .refreshable {
            viewModel.findAll()
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    showStudentDetail.toggle()
                }
                .fullScreenCover(isPresented: $showStudentDetail) {
                    StudentDetailView(firstName: $firstName, lastName: $lastName, rollNo: $rollNo)
                }
            }
        }
    }
}

struct StudentListView_Previews: PreviewProvider {
    static var previews: some View {
        StudentListView()
    }
}
