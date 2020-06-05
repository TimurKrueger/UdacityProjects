//
//  FlickrNetworking.swift
//  VirtualTourist
//
//  Created by Timur Krüger on 05.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//
import Foundation

struct FlickrData: Decodable {
  let photos: FlickrPhotos
}

struct FlickrPhotos: Decodable {
  let photo: [FlickrPhoto]
}

struct FlickrPhoto: Decodable {
  let url: String
}
