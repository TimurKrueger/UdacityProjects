//
//  ConfirmViewController.swift
//  OnTheMap
//
//  Created by Timur Krüger on 03.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//
import Foundation
import MapKit

class ConfirmViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    var student: StudentLocationRequest?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Handling
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setPin(lon: student!.longitude, lat: student!.latitude)
    }
    
    // MARK: - Post Student Location Button
    @IBAction func finish(_ sender: Any) {
        UdacityClient.postStudentLocation(locationRequest: student!) { (success, error) in
            if success {
                self.startOver()
            } else {
                self.showAlert(message: "Posting failed!")
            }
        }
    }

    @objc func startOver() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - MKMapViewDelegate: Set Map Location & Set Pin
    func setInitialMapLocation(lon: Double, lat: Double) {
        let initialLocation = CLLocationCoordinate2D(
            latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center: initialLocation, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        mapView.setRegion(region, animated: true)
    }
    
    func setPin(lon: Double, lat: Double) {
        setInitialMapLocation(lon: lon, lat: lat)
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = student!.mapString
        mapView.addAnnotation(annotation)
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Submit Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
