//
//  DateRangePickerView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 04/12/2022.
//

import StocksAPI
import SwiftUI

struct DateRangePickerView: View {
    let rangeTypes = ChartRange.allCases
    @Binding var selectedRange: ChartRange
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                ForEach(self.rangeTypes) { da in
                    Button {
                        self.selectedRange = da
                    } label: {
                        Text(da.title)
                            .font(.callout.bold())
                            .padding(8)
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                    .background {
                        if da == selectedRange {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.4))
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }
}

struct DateRangePickerView_Previews: PreviewProvider {
    @State static var dataRange = ChartRange.oneDay
    static var previews: some View {
        DateRangePickerView(selectedRange: $dataRange)
            .padding(.vertical)
            .previewLayout(.sizeThatFits)
    }
}
