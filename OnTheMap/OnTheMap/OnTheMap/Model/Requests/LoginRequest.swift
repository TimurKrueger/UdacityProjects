//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Timur Krüger on 03.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: LoginCredentials
}

struct LoginCredentials: Codable {
    let username: String
    let password: String
}
