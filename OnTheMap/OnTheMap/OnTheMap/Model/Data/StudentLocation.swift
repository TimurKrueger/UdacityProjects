//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Timur Krüger on 03.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//
import Foundation

struct StudentLocation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}

struct StudentLocationResponse: Decodable {
    let results: [StudentLocation]
}

struct StudentLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
