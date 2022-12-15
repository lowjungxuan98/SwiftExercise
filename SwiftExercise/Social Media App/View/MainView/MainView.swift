//
//  MainView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 15/12/2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        // MARK: TabView with Recent Post's And Profile Tabs

        TabView {
            Text("Recent Post's")
                .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Post's")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Profile")
                }
        }
        // Changing Tab Lable Tint to Black
        .tint(.black)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
