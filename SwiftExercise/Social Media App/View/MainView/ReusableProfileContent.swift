//
//  ReusableProfileContent.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 16/12/2022.
//

import SDWebImageSwiftUI
import SwiftUI

struct ReusableProfileContent: View {
    var user: User
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                HStack(spacing: 12) {
                    WebImage(url: user.userProfileURL).placeholder {
                        // MARK: Placeholder Image

                        Image("NullProfile")
                            .resizable()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 6) {
                        Text(user.username)
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text(user.userBio)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(3)

                        // MARK: Display Bio Link, if given while signing up profile page

                        if let bioLink = URL(string: user.userBioLink) {
                            Link(destination: bioLink) {
                                Text("\(user.userProfileURL)")
                                    .font(.callout)
                                    .tint(.blue)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .hAlign(.leading)
                }
                Text("Post's")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .hAlign(.leading)
                    .padding(.vertical, 15)
            }
            .padding(15)
        }
    }
}
