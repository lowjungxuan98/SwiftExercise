//
//  FlightApp.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 26/11/2022.
//

import SwiftUI

struct FlightApp: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            Home(size: size, safeArea: safeArea)
                .ignoresSafeArea(.container, edges: .vertical)
        }
    }
}

struct FlightApp_Previews: PreviewProvider {
    static var previews: some View {
        FlightApp()
    }
}
