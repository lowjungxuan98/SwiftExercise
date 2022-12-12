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
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let size = $0.size
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
                                    .navigationBarBackButtonHidden(true)
                            case .parallaxCardEffect:
                                ParallaxCardEffect()
                            case .core_data:
                                TaskManagerView()
                                    .navigationTitle(page.label)
                                    .navigationBarTitleDisplayMode(.inline)
                                    .environmentObject(TaskViewModel())
                                    .preferredColorScheme(.light)
                            case .task_management_ui:
                                Task2View()
                                    .navigationBarBackButtonHidden(true)
                                    .preferredColorScheme(.light)
                            case .flight_app:
                                FlightApp()
                                    .navigationBarBackButtonHidden(true)
                            case .magnification_app:
                                MagnificationApp()
                            case .scrollable_header:
                                ScrollableHeader(safeArea: safeArea, size: size)
                                    .preferredColorScheme(.dark)
                                    .ignoresSafeArea(.container, edges: .top)
                                    .navigationBarBackButtonHidden(true)
                            case .stock_app:
                                StockApp()
                                    .navigationBarTitleDisplayMode(.inline)
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarHidden(true)
                            case .social_media_app:
                                SocialMediaApp()
                                    .preferredColorScheme(.light)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
