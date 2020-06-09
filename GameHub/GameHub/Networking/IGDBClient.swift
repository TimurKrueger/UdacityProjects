//
//  IGDBClient.swift
//  GameHub
//
//  Created by Timur Krüger on 08.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import Foundation

class IGDBClient {
    let apiKey = "66c9afc004a2805ee2e1a56ad304f958"
    let base = "https://api-v3.igdb.com"
    let appName = "TUM's App"
    
    func getGames(completionHandler: @escaping (_ success: Bool, _ errorString: String?, Data?) -> Void) {
        let url = URL(string: "https://api-v3.igdb.com/games")!
        let session = URLSession.shared
        
        var requestHeader = URLRequest(url: url)
        requestHeader.httpBody = "fields age_ratings,aggregated_rating,aggregated_rating_count,alternative_names,artworks,bundles,category,checksum,collection,cover,created_at,dlcs,expansions,external_games,first_release_date,follows,franchise,franchises,game_engines,game_modes,genres,hypes,involved_companies,keywords,multiplayer_modes,name,parent_game,platforms,player_perspectives,popularity,pulse_count,rating,rating_count,release_dates,screenshots,similar_games,slug,standalone_expansions,status,storyline,summary,tags,themes,time_to_beat,total_rating,total_rating_count,updated_at,url,version_parent,version_title,videos,websites;".data(using: .utf8, allowLossyConversion: false)
        requestHeader.httpMethod = "POST"
        requestHeader.setValue(apiKey, forHTTPHeaderField: "user-key")
        requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: requestHeader as URLRequest) { (data, response, error) in
            guard let data = data else {
                completionHandler(false, error?.localizedDescription, nil)
                return
            }
            completionHandler(true, nil, data)
        }
        task.resume()
    }
}
