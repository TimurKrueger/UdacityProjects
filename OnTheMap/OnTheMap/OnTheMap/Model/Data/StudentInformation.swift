//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Timur Krüger on 02.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//
import Foundation

struct Auth {
    static var sharedInstance = Auth()
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var locations = [StudentLocation]()
}

struct LoginResponse: Codable {
    let account: AccountResponse
    let session: SessionResponse
}

struct AccountResponse: Codable {
    let registered: Bool
    let key: String
}

struct SessionResponse: Codable {
    let id: String
    let expiration: String
}

