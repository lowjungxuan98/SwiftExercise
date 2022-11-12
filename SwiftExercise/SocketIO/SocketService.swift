//
//  SocketService.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/11/2022.
//

import SocketIO
import SwiftUI
class SocketService: ObservableObject {
    private var manager = SocketManager(socketURL: URL(string: "ws://localhost:3000")!, config: [.log(true), .compress])

    @Published var studentList = [StudentModel]()

    init() {
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { _, _ in
            print("Connected")
            socket.emit("student:findAll", "initialize")
        }
        socket.on("student:findAll") { data, _ in
            DispatchQueue.main.async {
                let item = data[0] as? [String: [AnyObject]]
                var tempList: [StudentModel] = []
                for tempItem in item!["data"]! {
                    tempList.append(
                        StudentModel(
                            id: tempItem["id"] as! Int,
                            firstName: tempItem["first_name"] as! String,
                            lastName: tempItem["last_name"] as! String,
                            rollNo: tempItem["roll_no"] as? Int,
                            createdAt: tempItem["createdAt"] as! String,
                            updatedAt: tempItem["updatedAt"] as! String
                        )
                    )
                }
                self.studentList = tempList
                print("Object type: \(tempList)")
            }
        }
        socket.connect()
    }
}
