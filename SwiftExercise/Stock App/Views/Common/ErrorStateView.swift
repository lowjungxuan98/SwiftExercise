//
//  ErrorStateView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 04/12/2022.
//

import SwiftUI

struct ErrorStateView: View {
    let error:String
    var retryCallBack:(() -> ())?
    var body: some View {
        HStack{
            Spacer()
            VStack(spacing: 16) {
                Text(error)
                if let retryCallBack{
                    Button("Retry",action: retryCallBack)
                        .buttonStyle(.borderedProminent)
                }
            }
            Spacer()
        }
        .padding(64)
    }
}

struct ErrorStateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ErrorStateView(error: "An Error Ocurred") {}
                .previewDisplayName("With Retry Button")
            ErrorStateView(error: "An Error Ocurred") {}
                .previewDisplayName("Without Retry Button")
        }
    }
}
