//
//  IGDBData.swift
//  GameHub
//
//  Created by Timur Krüger on 08.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import UIKit

// MARK: - Search by Name
struct Game: Codable {
    let id: Int
    let popularity: Double
    let name: String
    let url: String
}

struct CoverURL: Codable {
    let game: Int
    let url: String
}

struct CoverImages {
    let id: Int
    let image: UIImage!
}

// MARK: - Search by Genre
struct Genre: Codable {
    let id: Int
    let name: String
}
