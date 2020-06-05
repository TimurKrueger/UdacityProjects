//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Timur Krüger on 01.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - View Handling
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        activityIndicator.startAnimating()
    
        if Auth.sharedInstance.locations.isEmpty {
            UdacityClient.getStudentLocation { (success, error) in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
                if success {
                    self.loadMap()
                } else {
                    print("Error while loading data!")
                }
            }
        } else {
            loadMap()
        }
    }
    
    // MARK: - Load Map
    func loadMap() {
        let location = Auth.sharedInstance.locations.first!
        setMapInitialLocation(lon: location.longitude, lat: location.latitude)
        
        var mapAnnotations = [MKPointAnnotation]()
        
        for student in Auth.sharedInstance.locations {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = student.firstName + " " + student.lastName
            annotation.subtitle = student.mediaURL
            mapAnnotations.append(annotation)
        }
        mapView.addAnnotations(mapAnnotations)
    }
    
    // MARK: - Initialize Map
    func setMapInitialLocation(lon: Double, lat: Double) {
        let initialLocation = CLLocationCoordinate2D(
            latitude: lat, longitude: lon)
        let currentRegion = MKCoordinateRegion(center: initialLocation, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        mapView.setRegion(currentRegion, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var mapPinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        
        if mapPinView == nil {
            mapPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            mapPinView!.canShowCallout = true
            mapPinView!.pinTintColor = .red
            mapPinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            mapPinView!.annotation = annotation
        }
        return mapPinView
    }
    
    // MARK: - Pin URL Response
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let open = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: open)!, options: [:], completionHandler: nil)
            }
        }
    }
}
