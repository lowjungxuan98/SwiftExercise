//
//  FlightDetailView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 29/11/2022.
//

import SwiftUI

struct FlightDetailsView: View {
    var alignment: HorizontalAlignment = .leading
    var place: String
    var code: String
    var timing: String

    var body: some View {
        VStack(alignment: alignment, spacing: 6) {
            Text(place)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            Text(code)
                .font(.title)
                .foregroundColor(.white)
            Text(timing)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
}

struct FlightDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        FlightDetailsView(place: "Los Angeles", code: "LAS", timing: "23 NOV, 03:30")
            .previewLayout(.sizeThatFits)
    }
}
