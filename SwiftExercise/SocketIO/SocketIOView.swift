//
//  SocketIOView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/11/2022.
//

import SwiftUI

struct SocketIOView: View {
    @ObservedObject var service = SocketService()
    var body: some View {
        List {
            ForEach(service.studentList, id: \.id) { item in
                HStack {
                    Text(item.firstName)
                    Text(item.lastName)
                }
            }
        }
        .listStyle(.plain)
    }
}

struct SocketIOView_Previews: PreviewProvider {
    static var previews: some View {
        SocketIOView()
    }
}
