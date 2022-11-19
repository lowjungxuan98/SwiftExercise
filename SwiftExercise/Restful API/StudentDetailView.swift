//
//  StudentDetailView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/11/2022.
//

import SwiftUI

struct StudentDetailView: View {
    @EnvironmentObject var viewModel: StudentViewModel
    var data: StudentModel? = nil
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var rollNo: Int
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                TextField("First Name", text: $firstName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(6)
                    .padding(.bottom)
                TextField("Last Name", text: $lastName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(6)
                    .padding(.bottom)
                TextField("Roll No", value: $rollNo, format: .number)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(6)
                    .padding(.bottom)
                Text(data?.lastName ?? "")
                Button("Done") {
                    if !firstName.isEmpty, !lastName.isEmpty, !(rollNo == 0) {
                        let parameters: [String: Any] = ["first_name": firstName, "last_name": lastName, "roll_no": String(rollNo)]
                        viewModel.create(parameters: parameters)
                        viewModel.findAll()
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.borderedProminent)
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Exit") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("New Student")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//
// struct StudentDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        StudentDetailView()
//    }
// }
