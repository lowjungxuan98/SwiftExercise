//
//  Home.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 26/11/2022.
//

import SwiftUI

struct Home: View {
    // MARK: View Bounds

    var size: CGSize
    var safeArea: EdgeInsets

    // MARK: Gesture Properties

    @State var offsetY: CGFloat = 0
    @State var currentCardIndex: CGFloat = 0

    // MARK: Animator State Object

    @StateObject var animator: Animator = .init()

    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .overlay(alignment: .bottomTrailing, content: {
                    Button {} label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .frame(width: 40, height: 40)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.35), radius: 5, x: 5, y: 5)
                            }
                    }
                    .offset(x: -15, y: 15)
                })
                .zIndex(1)
            PaymentCardsView()
                .zIndex(0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlayPreferenceValue(RectKey.self) { value in
            if let anchor = value["PLANEBOUNDS"] {
                GeometryReader { proxy in
                    /// Extracting Rect From Anchor Using Geometry Reader
                    let rect = proxy[anchor]

                    Image("Airplane")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: rect.width, height: rect.height)
                        .offset(x: rect.minX, y: rect.minY)
                }
            }
        }
        .background {
            Color("BG 1")
                .ignoresSafeArea()
        }
    }

    // MARK: Top Header View

    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 0.4)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                FlightDetailView(place: "Los Angeles", code: "LAS", timing: "23 Nov, 03:30")
                VStack(spacing: 8) {
                    Image(systemName: "chevron.right")
                        .font(.title2)

                    Text("4h 15m")
                }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                FlightDetailView(alignment: .trailing, place: "New York", code: "NYC", timing: "23 Nov, 07:15")
            }
            .padding(.top, 20)

            // MARK: Airplane Image View

            Image("Airplane")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 160)
                /// hiding the original plane
                .opacity(0)
                .anchorPreference(key: RectKey.self, value: .bounds, transform: { anchor in
                    return ["PLANEBOUNDS": anchor]
                })
                .padding(.bottom)
        }
        .padding([.horizontal, .top], 15)
        .padding(.top, safeArea.top)
        .background {
            Rectangle()
                .fill(.linearGradient(colors: [
                    Color("BlueTop"),
                    Color("BlueTop"),
                    Color("BlueBottom")
                ], startPoint: .top, endPoint: .bottom))
        }
        .rotation3DEffect(.init(degrees: animator.startAnimation ? 90 : 0), axis: (x: 1, y: 0, z: 0), anchor: .init(x: 0.5, y: 0.8))
        .offset(y: animator.startAnimation ? -100 : 0)
    }

    // MARK: Credit Cards View

    @ViewBuilder
    func PaymentCardsView() -> some View {
        VStack {
            Text("SELECT PAYMENT METHOD")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.vertical)
            GeometryReader { _ in
                VStack(spacing: 0) {
                    ForEach(sampleCards.indices, id: \.self) { index in
                        CardView(index: index)
                    }
                }
                .padding(.horizontal, 30)
                .offset(y: offsetY)
                .offset(y: currentCardIndex * -200.0)

                // MARK: Gradient View

                Rectangle()
                    .fill(.linearGradient(colors: [
                        .clear,
                        .clear,
                        .clear,
                        .clear,
                        .white.opacity(0.3),
                        .white.opacity(0.7),
                        .white
                    ], startPoint: .top, endPoint: .bottom))
                    .allowsHitTesting(false)

                // MARK: Purchase Button

                Button(action: buyTicket, label: {
                    Text("Confirm $1,536.00")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background {
                            Capsule()
                                .fill(Color("BlueTop").gradient)
                        }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, safeArea.bottom == 0 ? 15 : safeArea.bottom)
            }
            .coordinateSpace(name: "SCROLL")
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged { value in
                    offsetY = value.translation.height * 0.3
                }.onEnded { value in
                    let translation = value.translation.height
                    withAnimation(.easeInOut) {
                        // MARK: Increaseing/Decreasing Index Based on Condition

                        // 100 -> Since Card Height = 200
                        if translation > 0, translation > 100, currentCardIndex > 0 {
                            currentCardIndex -= 1
                        }
                        if translation < 0, -translation > 100, currentCardIndex < CGFloat(sampleCards.count - 1) {
                            currentCardIndex += 1
                        }
                        offsetY = .zero
                    }
                }
        )
        .background {
            Color.white
                .ignoresSafeArea()
        }
    }

    func buyTicket() {
        /// Animating Content
        withAnimation(.easeInOut(duration: 0.85)) {
            animator.startAnimation = true
        }
    }

    // MARK: Card View

    @ViewBuilder
    func CardView(index: Int) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / size.height
            let constrainedProgress = progress > 1 ? 1 : progress < 0 ? 0 : progress

            Image(sampleCards[index].cardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)

                // MARK: Shadow

                .shadow(color: .black.opacity(0.14), radius: 8, x: 6, y: 6)

                // MARK: Stacked Card Animation

                .rotation3DEffect(.init(degrees: constrainedProgress * 40.0), axis: (x: 1, y: 0, z: 0), anchor: .bottom)

                .padding(.top, progress * -160)
                // Moving Current Card to the top
                .offset(y: progress < 0 ? progress * 250 : 0)
        }
        .frame(height: 200)
        .zIndex(Double(sampleCards.count - index))
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        FlightApp()
    }
}

// MARK: ObserablableObject that hold all animation properties

class Animator: ObservableObject {
    /// Animation Properties
    @Published var startAnimation: Bool = false
}

// MARK: Anchor Preference Key

struct RectKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
