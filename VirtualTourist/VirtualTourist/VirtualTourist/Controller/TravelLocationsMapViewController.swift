//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Timur Krüger on 04.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class TravelLocationsViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var taggedAnnotation: MKAnnotation!
    let dataContainer = DataContainer(containerName: "VirtualTourist")
    var pins: [Pin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
}
