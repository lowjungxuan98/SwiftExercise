//
//  DetailView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 29/11/2022.
//

import SwiftUI


// MARK: Detail View UI

struct DetailView: View {
    // MARK: View Bounds

    var size: CGSize
    var safeArea: EdgeInsets
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                VStack {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    Text("Your Order has submitted")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    Text("We are waiting for booking confirmation")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 30)
                .padding(.bottom, 40)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.white.opacity(0.1))
                }

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
                .padding(15)
                .padding(.bottom, 70)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.ultraThinMaterial)
                }
                .padding(.top, -20)
            }
            .padding(.horizontal, 20)
            .padding(.top, safeArea.top + 15)
            .padding([.horizontal, .bottom], 15)
            .background {
                Rectangle()
                    .fill(Color("BlueTop"))
                    .padding(.bottom, 80)
            }

            // MARK: Contact Information View

            GeometryReader { _ in

                // MARK: For smaller device adoption

                ViewThatFits {
                    ContactInformation()
                    ScrollView(.vertical, showsIndicators: false) {
                        ContactInformation()
                    }
                }
            }
        }
    }

    @ViewBuilder
    func ContactInformation() -> some View {
        VStack(spacing: 15) {
            HStack {
                InfoView(title: "Flight", subtitle: "AR580")
                InfoView(title: "Class", subtitle: "Premium")
                InfoView(title: "Aircraft", subtitle: "B 737-900")
                InfoView(title: "Possibility", subtitle: "AR580")
            }
            ContactView(name: "Low Jung Xuan", email: "lowjungxuan@gmail.com", profile: "User1")
            ContactView(name: "Low", email: "ub.bee8@gmail.com", profile: "User2")
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Price")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                Text("$1,536.00")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.leading, 15)

            // MARK: Home Screen Button

            Button {} label: {
                Text("Go to Home Screen")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background {
                        Capsule()
                            .fill(Color("BlueTop").gradient)
                    }
            }
            .padding(.top, 15)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, safeArea.bottom)
        }
        .padding(15)
        .padding(.top, 20)
    }

    @ViewBuilder
    func InfoView(title: String, subtitle: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)

            Text(subtitle)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    func ContactView(name: String, email: String, profile: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                Text(email)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(profile)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipShape(Circle())
        }
        .padding(.horizontal, 15)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        FlightApp()
    }
}
