//
//  LogoutRequest.swift
//  OnTheMap
//
//  Created by Timur Krüger on 03.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import Foundation

struct LogoutRequest: Codable {
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
    }
}
