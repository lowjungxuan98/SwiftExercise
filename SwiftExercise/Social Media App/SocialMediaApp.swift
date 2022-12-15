//
//  SocialMediaApp.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 08/12/2022.
//

import Firebase
import SwiftUI

struct SocialMediaApp: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        // MARK: Redirecting User Based on Log Status

        if logStatus {
            MainView()
        } else {
            LoginView()
        }
    }
}

// struct SocialMediaApp_Previews: PreviewProvider {
//    static var previews: some View {
//        SocialMediaApp()
//    }
// }
