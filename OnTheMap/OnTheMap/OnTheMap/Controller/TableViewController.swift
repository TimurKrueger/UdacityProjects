//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Timur Krüger on 01.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//
import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Handling
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if Auth.sharedInstance.locations.isEmpty {
            UdacityClient.getStudentLocation { (success, error) in
                if success {
                    self.tableView.reloadData()
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Failed to load data!")
                    }
                }
            }
        } else {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  Auth.sharedInstance.locations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student =  Auth.sharedInstance.locations[indexPath.row]
        let url = URL(string: student.mediaURL)
        if let url = url {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Wrong URL!")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")!
        let student =  Auth.sharedInstance.locations[indexPath.row]
        cell.textLabel?.text = student.firstName + " " + student.lastName
        cell.detailTextLabel?.text = student.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin.png")
        return cell
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Failed loading data!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
