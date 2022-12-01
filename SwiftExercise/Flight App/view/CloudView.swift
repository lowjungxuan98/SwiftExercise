//
//  CloudView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 01/12/2022.
//

import SwiftUI

struct CloudView: View {
    var delay: Double
    var size: CGSize
    @State private var moveCloud: Bool = false
    var body: some View {
        ZStack {
            Image("Cloud")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 3)
                .offset(x: moveCloud ? -size.width * 2 : size.width * 2)
        }
        .onAppear {
            /// Duration  = Speed of the movement of the cloud
            withAnimation(.easeInOut(duration: 5.5).delay(delay)) {
                moveCloud.toggle()
            }
        }
    }
}
