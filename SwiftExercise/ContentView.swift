//
//  ContentView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/11/2022.
//

import SwiftUI

struct ContentView: View {
    let page = pages
    @State var showModal = false
    var body: some View {
        NavigationView {
            List {
                ForEach(pages, id: \.self) { page in
                    NavigationLink {
                        switch page {
                        case "Restful API": StudentListView()
                        case "Socket IO": SocketIOView()
                        default: StudentListView()
                        }
                    } label: {
                        Text(page)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Swift Exercise")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
