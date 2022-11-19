//
//  ParallaxCardEffect.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 20/11/2022.
//

import SwiftUI

struct ParallaxCardEffect: View {
    // MARK: Gesture Propertise

    @State var offset: CGSize = .zero
    var body: some View {
        GeometryReader {
            let size = $0.size
            let imageSize = size.width * 0.7
            VStack {
                Image("Shoe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize)
                    .rotationEffect(.init(degrees: -30))
                    .offset(x: -5, y: -20)
                    .zIndex(1)
                    .offset(x: offset2Angle().degrees * 5, y: offset2Angle(true).degrees * 5)

                Text("NIKE AIR")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .padding(.top, -60)
                    .padding(.bottom, 50)
                    .zIndex(0)

                VStack(alignment: .leading, spacing: 10) {
                    Text("NIKE")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .fontWidth(.compressed)

                    HStack {
                        BlendedText("AIR JORDAN 1 MID SE")
                        Spacer(minLength: 0)
                        BlendedText("$128")
                    }
                    HStack {
                        BlendedText("YOUR NEXT SHOES")
                        Spacer(minLength: 0)
                        Button {} label: {
                            Text("BUY")
                                .fontWeight(.bold)
                                .foregroundColor(Color("BG"))
                                .padding(.vertical, 12)
                                .padding(.horizontal, 15)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color("Yellow"))
                                        .brightness(-0.1)
                                }
                        }
                    }
                    .padding(.top, 14)
                    /// Nike Logo
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundColor(.white)
            .padding(.top, 65)
            .padding(.horizontal, 15)
            .frame(width: imageSize)
            .background {
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .fill(Color("BG"))

                    Circle()
                        .fill(Color("Yellow"))
                        .frame(width: imageSize, height: imageSize)
                        .scaleEffect(1.2, anchor: .leading)
                        .offset(x: imageSize * 0.3, y: -imageSize * 0.25)
                }
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            }
            .rotation3DEffect(offset2Angle(true), axis: (x: -1, y: 0, z: 0))
            .rotation3DEffect(offset2Angle(), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(offset2Angle(true) * 0.1, axis: (x: 0, y: 0, z: 1))
            .scaleEffect(0.9)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(DragGesture()
                .onChanged { value in
                    offset = value.translation
                }
                .onEnded { _ in
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.32, blendDuration: 0.32)) {
                        offset = .zero
                    }
                }
            )
        }
    }

    // MARK: Converting Offset Into X, Y Angles

    func offset2Angle(_ isVertical: Bool = false) -> Angle {
        let progress = (isVertical ? offset.height : offset.width) / (isVertical ? screenSize.height : screenSize.width)
        return .init(degrees: progress * 20)
    }

    // MARK: Device Screen Size

    var screenSize: CGSize = {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }

        return window.screen.bounds.size
    }()

    @ViewBuilder
    func BlendedText(_ text: String) -> some View {
        Text(text)
            .font(.title3)
            .fontWeight(.semibold)
            .fontWidth(.condensed)
            .blendMode(.difference)
    }
}

struct ParallaxCardEffect_Previews: PreviewProvider {
    static var previews: some View {
        ParallaxCardEffect()
    }
}
