//
//  ContentView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/11/2022.
//

import SwiftUI

struct ContentView: View {
//    let page = pages
    @State var showModal = false
    var body: some View {
        NavigationView {
            List {
                ForEach(Pages.allCases, id: \.self) { page in
                    NavigationLink {
                        switch page {
                        case .restApi:
                            StudentListView()
                        case .socketIO:
                            SocketIOView()
                        case .animatedStickyHeader:
                            AnimatedStickyHeaderMainView()
                        case .parallaxCardEffect:
                            ParallaxCardEffect()
                        }
                    } label: {
                        Text(page.label)
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
