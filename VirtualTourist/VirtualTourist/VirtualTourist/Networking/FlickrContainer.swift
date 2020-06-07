//
//  FlickrContainer.swift
//  VirtualTourist
//
//  Created by Timur Krüger on 07.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

struct FlickrContainer: Decodable {
    let photos: FlickrPhotos
}

struct FlickrPhotos: Decodable {
    let photo: [FlickrPhoto]
}

struct FlickrPhoto: Decodable {
    let url_n: String
}
