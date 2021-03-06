//
//  IGDBClient.swift
//  GameHub
//
//  Created by Timur Krüger on 08.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import Foundation

class IGDBClient {
    
    // MARK: - Properties
    let apiKey = "66c9afc004a2805ee2e1a56ad304f958"
    
    // MARK: - Endpoints
    enum Endpoints {
        static let base = "https://api-v3.igdb.com"
        
        case games
        case covers
        
        var stringValue: String {
            switch self {
            case .games: return Endpoints.base + "/games"
            case .covers: return Endpoints.base + "/covers"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: - getSearchResponse by Name
    class func getSearchResponse(gameName: String, completionHandler:@escaping(Data?,Error?) -> Void){
        let url = Endpoints.games.url
        let session = URLSession.shared
        
        var requestHeader = URLRequest(url: url)
        requestHeader.httpBody = "search \"\(gameName)\"; fields name, id, popularity, url; limit 25;".data(using: .utf8, allowLossyConversion: false)
        requestHeader.httpMethod = "POST"
        requestHeader.setValue("66c9afc004a2805ee2e1a56ad304f958", forHTTPHeaderField: "user-key")
        requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: requestHeader as URLRequest) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error?.localizedDescription as? Error)
                return
            }
            completionHandler(data, nil)
        }
        task.resume()
    }
    
    // MARK: - getSearchResponse by Genre
    class func getSearchResponseByGenre(genreId: Int, completionHandler:@escaping(Data?,Error?) -> Void){
         let url = Endpoints.games.url
         let session = URLSession.shared
         
         var requestHeader = URLRequest(url: url)
         requestHeader.httpBody = "fields name, id, popularity, url; where genres = (\(genreId)); limit 25; sort popularity desc;".data(using: .utf8, allowLossyConversion: false)
         requestHeader.httpMethod = "POST"
         requestHeader.setValue("66c9afc004a2805ee2e1a56ad304f958", forHTTPHeaderField: "user-key")
         requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
         
         let task = session.dataTask(with: requestHeader as URLRequest) { (data, response, error) in
             guard let data = data else {
                 completionHandler(nil, error?.localizedDescription as? Error)
                 return
             }
             completionHandler(data, nil)
         }
         task.resume()
     }
    
    
    // MARK: - getGameData
    class func getGameData(gameId: Int, completion: @escaping (Data?, Error?) -> Void) {
        let url = Endpoints.games.url
        let session = URLSession.shared
        
        var requestHeader = URLRequest(url: url)
        requestHeader.httpBody = "fields cover, name; where id = \(gameId);".data(using: .utf8, allowLossyConversion: false)
        requestHeader.httpMethod = "POST"
        requestHeader.setValue("66c9afc004a2805ee2e1a56ad304f958", forHTTPHeaderField: "user-key")
        requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: requestHeader as URLRequest) { (data, response, error) in
            guard let data = data else {
                completion(nil, error?.localizedDescription as? Error)
                return
            }
            completion(data, nil)
        }
        task.resume()
        
    }
    
    // MARK: - getCovers
    class func getCovers(gameId: Int, completion: @escaping (Data?, Error?) -> Void) {
        let url = Endpoints.covers.url
        let session = URLSession.shared
        
        var requestHeader = URLRequest(url: url)
        requestHeader.httpBody = "fields game, url; where game = \(gameId); limit 25;".data(using: .utf8, allowLossyConversion: false)
        requestHeader.httpMethod = "POST"
        requestHeader.setValue("66c9afc004a2805ee2e1a56ad304f958", forHTTPHeaderField: "user-key")
        requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: requestHeader as URLRequest) { (data, response, error) in
            guard let data = data else {
                completion(nil, error?.localizedDescription as? Error)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
    
    // MARK: - getData
    class func getData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil, error?.localizedDescription as? Error)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
}
