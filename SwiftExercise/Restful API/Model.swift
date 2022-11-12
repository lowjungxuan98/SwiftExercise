//
//  Models.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/11/2022.
//

import Foundation
struct StudentModel: Codable {
    let id: Int
    let firstName, lastName: String
    let rollNo: Int?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case rollNo = "roll_no"
        case createdAt, updatedAt
    }
}
