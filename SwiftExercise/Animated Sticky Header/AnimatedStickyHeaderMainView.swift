//
//  AnimatedStickyHeaderMainView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 19/11/2022.
//

import SwiftUI

struct AnimatedStickyHeaderMainView: View {
    // MARK: - Header Animation Properties

    @State var offsetY: CGFloat = 0
    @State var searchText = ""
    @State var showSearchBar = false
    var body: some View {
        GeometryReader { proxy in
            let safeAreaTop = proxy.safeAreaInsets.top
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HeaderView(safeAreaTop)
                        .offset(y: -offsetY)
                        .zIndex(1)

                    // MARK: Scroll Content Goes Here

                    VStack {
                        ForEach(1 ... 10, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.blue)
                                .frame(height: 220)
                        }
                    }
                    .padding(15)
                    .zIndex(0)
                }
                .offset(coordinateSpace: .named("SCROLL")) { offset in
                    offsetY = offset
                    showSearchBar = (-offset > 80) && showSearchBar
                }
            }
            .coordinateSpace(name: "SCROLL")
            .edgesIgnoringSafeArea(.top)
        }
    }

    // MARK: - Header View

    @ViewBuilder
    func HeaderView(_ safeAreaTop: CGFloat) -> some View {
        // MARK: - Reduced Header Height will be 80

        let progress = -(offsetY / 80) > 1 ? -1 : (offsetY > 0 ? 0 : (offsetY / 80))

        VStack {
            HStack(spacing: 15) {
                HStack(spacing: 15) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                    TextField("Search", text: $searchText)
                        .tint(.white)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.black)
                        .opacity(0.15)
                }
                .opacity(showSearchBar ? 1 : 1 + progress)

                Button {} label: {
                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .background {
                            Circle()
                                .fill(.white)
                                .padding(-2)
                        }
                }
                .opacity(showSearchBar ? 0 : 1)
                .overlay {
                    if showSearchBar {
                        // MARK: Displaying XMark Button

                        Button {
                            showSearchBar.toggle()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                }
            }

            HStack(spacing: 0) {
                CustomButton(symbolImage: "rectangle.portrait.and.arrow.forward", title: "Deposit") {}
                CustomButton(symbolImage: "dollarsign", title: "Withdraw") {}
                CustomButton(symbolImage: "qrcode", title: "QR Code") {}
                CustomButton(symbolImage: "qrcode.viewfinder", title: "Scanning") {}
            }

            // MARK: - Shrinking Horizontal

            .padding(.horizontal, -progress * 50)
            .padding(.top, 10)

            // MARK: - Moving Up when Scrolling Started

            .offset(y: progress * 60)
            .opacity(showSearchBar ? 0 : 1)
        }

        // MARK: Displaying Search Button

        .overlay(alignment: .topLeading, content: {
            Button {
                showSearchBar.toggle()
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .offset(x: 13, y: 7)
            .opacity(showSearchBar ? 0 : -progress)

        })
        .animation(.easeInOut(duration: 0.2), value: showSearchBar)
        .environment(\.colorScheme, .dark)
        .padding([.horizontal, .bottom], 15)
        .padding(.top, safeAreaTop + 10)
        .background {
            Rectangle()
                .fill(.red.gradient)
                .padding(.bottom, -progress * 80)
        }
    }

    @ViewBuilder
    func CustomButton(symbolImage: String, title: String, onClick: @escaping () -> ()) -> some View {
        // MARK: - Fading Out Soon Than The NavBar Animation

        let progress = -(offsetY / 40) > 1 ? -1 : (offsetY > 0 ? 0 : (offsetY / 40))
        Button {} label: {
            VStack(spacing: 8) {
                Image(systemName: symbolImage)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                    .frame(width: 35, height: 35)
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.white)
                    }
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .opacity(1 + progress)

            // MARK: Displaying Alternative Icon

            .overlay {
                Image(systemName: symbolImage)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(-progress)
                    .offset(y: -10)
            }
        }
    }
}

// MARK: - Offset View extension

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Header View

extension View {
    @ViewBuilder
    func offset(coordinateSpace: CoordinateSpace, completion: @escaping (CGFloat) -> ()) -> some View {
        overlay {
            GeometryReader { proxy in
                let minY = proxy.frame(in: coordinateSpace).minY
                Color.clear
                    .preference(key: OffsetKey.self, value: minY)
                    .onPreferenceChange(OffsetKey.self) { value in
                        completion(value)
                    }
            }
        }
    }
}

struct AnimatedStickyHeaderMainView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedStickyHeaderMainView()
    }
}
