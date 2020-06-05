//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Timur Krüger on 02.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//
import Foundation

class UdacityClient {
    
    // MARK: - Endpoints
    enum Endpoints {
        static let limit = 100
        case user
        case session
        case student
        
        var stringValue: String {
            switch self {
            case .user: return "https://onthemap-api.udacity.com/v1/users"
            case .session: return "https://onthemap-api.udacity.com/v1/session"
            case .student: return "https://onthemap-api.udacity.com/v1/StudentLocation" + "?limit=\(Endpoints.limit)&order=-updatedAt"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: - Login Post Request
    class func login(username:String,password:String,completion:@escaping(Data?,Error?)->Void){
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = LoginRequest(udacity:LoginCredentials(username: username, password: password))
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            completion(newData, nil)
            
        }
        task.resume()
    }
    
    // MARK: - Logout Delete Request
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false, error)
            }
            Auth.sharedInstance.firstName = ""
            Auth.sharedInstance.lastName = ""
            Auth.sharedInstance.locations = []
            Auth.sharedInstance.id = ""
            completion(true, nil)
        }
        task.resume()
    }
    
    // MARK: - Get User Information
    class func getUserInfo(userId: String, completion: @escaping(Data?,Error?) -> Void){
        let request = URLRequest(url: URL(string: Endpoints.user.stringValue + "/\(userId)")!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("failed to get data")
                print(error!)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            DispatchQueue.main.async {
                print(String(data: newData!, encoding: .utf8)!)
                completion(newData, nil)
            }
        }
        task.resume()
    }
    
    // MARK: - Student Location
    class func getStudentLocation(completion: @escaping (Bool, Error?)->Void) {
        let request = URLRequest(url: Endpoints.student.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Failed to get Student Location!")
                print(error!)
            }
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(StudentLocationResponse.self, from: data!)
                Auth.sharedInstance.locations = responseObject.results
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                completion(false, error)
                return
            }
        }
        task.resume()
    }
    
    // MARK: - Student Location Post Request
    class func postStudentLocation(locationRequest: StudentLocationRequest, completion: @escaping (Bool, Error?)->Void) {
        var request = URLRequest(url: Endpoints.student.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(locationRequest)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(true, nil)
            }
        }
        task.resume()
    }
}
