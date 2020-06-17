import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let url = URL(string: "https://api-v3.igdb.com/platforms")!
var requestHeader = URLRequest(url: url)
requestHeader.httpBody = "fields abbreviation,alternative_name,category,checksum,created_at,generation,name,platform_logo,product_family,slug,summary,updated_at,url,versions,websites;".data(using: .utf8, allowLossyConversion: false)
requestHeader.httpMethod = "POST"
requestHeader.setValue("66c9afc004a2805ee2e1a56ad304f958", forHTTPHeaderField: "user-key")
requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
URLSession.shared.dataTask(with: requestHeader) {
    data, response, error in
    if error != nil { // Handle error
        return
    }
    print(String(data: data!, encoding: .utf8)!)
}.resume()

