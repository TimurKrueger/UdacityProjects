//
//  InformationPostViewController.swift
//  OnTheMap
//
//  Created by Timur Krüger on 02.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class InformationPostViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    var student: StudentLocationRequest?
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var link: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Handling
    override func viewDidLoad() {
        super.viewDidLoad()
        location.delegate = self
        link.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        subscribeToKeyboardNotificationsShow()
        subscribeToKeyboardNotificationsHide()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromKeyboardNotificationsShow()
        unsubscribeFromKeyboardNotificationsHide()
    }
    
    // MARK: - Find Location of Input
    @IBAction func findLocation(_ sender: Any) {
        activityIndicator.startAnimating()
        if link.text == "Link" || link.text == "" {
            showAlert(message: "Link is empty!")
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location.text ?? "") { (clplacemarks, error) in    self.activityIndicator.stopAnimating()
            if let clplacemark = clplacemarks?.first {
                self.placeStudentLocationRequest(clplacemark: clplacemark)
            } else {
                self.showAlert(message: "Place could not be found!")
            }
        }
    }
    
    // MARK: - Place Location based on Input
    func placeStudentLocationRequest(clplacemark: CLPlacemark) {
        UdacityClient.getUserInfo(userId: Auth.sharedInstance.id) { (data, error) in
            if error == nil {
                let request = StudentLocationRequest(
                    uniqueKey: Auth.sharedInstance.id,
                    firstName: Auth.sharedInstance.firstName,
                    lastName: Auth.sharedInstance.lastName,
                    mapString: self.location.text!,
                    mediaURL: self.link.text!,
                    latitude: clplacemark.location!.coordinate.latitude,
                    longitude: clplacemark.location!.coordinate.longitude)
                self.student = request
                self.performSegue(withIdentifier: "confirmController", sender: nil)
            } else {
                print(error!)
            }
        }
    }
    
    // MARK: - Segue to Confirm View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ConfirmViewController
        vc.student = self.student
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if location.text == "Location" && location.isEditing {
            location.text = ""
        }
        if link.text == "Link" && link.isEditing {
            link.text = ""
        }
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Posting Failure", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard Notifications
    @objc func keyboardWillShow(_ notification: Notification) {
        if ((location.isEditing || link.isEditing) && view.frame.origin.y == 0) {
            view.frame.origin.y = (-getKeyboardHeight(notification: notification) / 2)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if((location.isEditing || link.isEditing) && view.frame.origin.y != 0) {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotificationsHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotificationsHide() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func subscribeToKeyboardNotificationsShow() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotificationsShow() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}
