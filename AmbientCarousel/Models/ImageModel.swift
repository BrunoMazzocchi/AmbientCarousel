//
//  ImageModel.swift
//  AmbientCarousel
//
//  Created by Bruno Mazzocchi on 4/1/25.
//

import SwiftUI

struct ImageModel: Identifiable {
    var id: String = UUID().uuidString
    var altText: String
    var image: String
}

let images: [ImageModel] = [
    .init(altText: "Image 1", image: "image1"),
    .init(altText: "Image 2", image: "image2"),
    .init(altText: "Image 3", image: "image3"),
    .init(altText: "Image 4", image: "image4"),
]
