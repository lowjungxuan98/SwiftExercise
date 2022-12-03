//
//  Album.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 02/12/2022.
//

import SwiftUI

struct Album: Identifiable {
    var id = UUID().uuidString
    var albumName: String
}

var albums: [Album] = [
    Album(albumName: "In Between"),
    Album(albumName: "More"),
    Album(albumName: "Big Jet Plane"),
    Album(albumName: "Empty Floor"),
    Album(albumName: "Black Hole Nights"),
    Album(albumName: "Rain On Me"),
    Album(albumName: "Stuck With U"),
    Album(albumName: "7 rings"),
    Album(albumName: "Bang Bang"),
    Album(albumName: "In Between"),
    Album(albumName: "More"),
    Album(albumName: "Big Jet Plane"),
    Album(albumName: "Empty Floor"),
    Album(albumName: "Black Hole Nights")
]
