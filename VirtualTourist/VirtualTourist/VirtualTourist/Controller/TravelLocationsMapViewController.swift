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
    var selectedAnnotation: MKAnnotation!
    let dataContainer = DataContainer(containerName: "VirtualTourist")
    var pins: [Pin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Segue to Photo Album Controller
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "showCollection", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhotoAlbumViewController
        vc.dataContainer = dataContainer
    }
}
