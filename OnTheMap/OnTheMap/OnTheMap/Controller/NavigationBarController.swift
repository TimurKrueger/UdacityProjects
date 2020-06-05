//
//  NavigationBarController.swift
//  OnTheMap
//
//  Created by Timur Krüger on 04.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//
import Foundation
import UIKit

class NavigationBarController: UITabBarController {
    
    // MARK: - View Handling
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refreshData()
    }
    
    // MARK: - Refresh Data Button
    @IBAction func refresh(_ sender: Any) {
        refreshData()
    }
    
    func refreshData() {
        UdacityClient.getStudentLocation { (success, error) in
            if success {
                return
            } else {
                print("Failed to refresh data")
            }
        }
    }
    
    // MARK: - Post Pin Button
    @IBAction func postPin(_sender: Any) {
        performSegue(withIdentifier: "postInformation", sender: self)
    }
    
    // MARK: - Logout Button
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
