//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Timur Krüger on 05.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//
import Foundation
import UIKit

class FlickrClient {
    static let base = "https://api.flickr.com/services/rest?method=flickr.photos.search&api_key=7e39eab55d0699d56e7404c52aa2s0f0&extras=url_n&format=json&safe_search=1&per_page=30&page=1&nojsoncallback=1"
    
    static func bbox(pin: Pin) -> String {
        let minLat = max(pin.latitude - 0.5, -90)
        let minLon = max(pin.longitude - 0.5, -180)
        let maxLat = min(pin.latitude + 0.5, 90)
        let maxLon = min(pin.longitude + 0.5, 180)
        return "&bbox=\(minLon),\(minLat),\(maxLon),\(maxLat)"
    }
    
    class func getSearchResult(pin: Pin, completion: @escaping ([FlickrPhoto]?, Error?) -> Void) {
        let page = Int.random(in: 1...10)
        let boundingBox = bbox(pin: pin)
        let urlString = base + "\(boundingBox)" + "&page=\(page)"
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                fatalError(error?.localizedDescription as! String)
            }
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(FlickrData.self, from: data!)
                DispatchQueue.main.async {
                    completion(responseObject.photos.photo, nil)
                }
            } catch {
                completion(nil, error)
                return
            }
        }
        task.resume()
    }
    
    class func downloadPicture(imageURL: URL, pin: Pin, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            guard let data = data else {
                fatalError("Error downloading pictures: \(error!.localizedDescription)")
            }
            completion(data, nil)
        }
        task.resume()
    }
}
