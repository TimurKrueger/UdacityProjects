//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Timur Krüger on 05.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import UIKit

class FlickrClient {
    
    // MARK: - Properties
     static let base = "https://api.flickr.com/services/rest?method=flickr.photos.search&api_key=7e39eab55d0699d56e7404c52aa2d0f0&extras=url_n&format=json&safe_search=1&per_page=30&page=1&nojsoncallback=1"
    
    static func boundingBox(pin: Pin) -> String {
        let minLatitude = max(pin.latitude - 0.75, -90)
        let minLongitude = max(pin.longitude - 0.75, -90)
        let maxLatitude = min(pin.latitude + 0.75, 90)
        let maxLongitude = min(pin.longitude + 0.75, 90)
        return "&bbox=\(minLongitude),\(minLatitude),\(maxLongitude),\(maxLatitude)"
    }
    
    // MARK: - Networking
    class func getSearchResult(pin: Pin, completion: @escaping ([FlickrPhoto]?, Error?) -> Void) {
        let page = Int.random(in: 1...10)
        let boundingBoxPin = boundingBox(pin: pin)
        let urlString = base + "\(boundingBoxPin)" + "&page=\(page)"
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                fatalError("Error reading URL!")
            }
            do {
                let decoder = JSONDecoder()

                print(String(data: data!, encoding: .utf8) as Any)
                let responseObject = try decoder.decode(FlickrContainer.self, from: data!)
        
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
                fatalError("Error downloading pictures!")
            }
            completion(data, nil)
        }
        task.resume()
    }
}
