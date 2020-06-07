//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Timur Krüger on 04.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    var selectedAnnotation: MKAnnotation!
    let dataContainer = DataContainer(containerName: "VirtualTourist")
    var pins: [Pin] = []
    
    // MARK: - App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataContainer.load()
        mapView.delegate = self
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureHandler(sender:))))
        
        if (UserDefaults.standard.bool(forKey: "hasLaunchedBefore") == true) {
            mapView.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: UserDefaults.standard.double(forKey: "latitude"),
                    longitude: UserDefaults.standard.double(forKey: "longitude")),
                span: MKCoordinateSpan(
                    latitudeDelta: UserDefaults.standard.double(forKey: "latitudeDelta"),
                    longitudeDelta: UserDefaults.standard.double(forKey: "longitudeDelta")))
            loadPins()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "latitude")
        UserDefaults.standard.set(mapView.region.center.longitude, forKey: "longitude")
        UserDefaults.standard.set(mapView.region.span.latitudeDelta, forKey: "latitudeDelta")
        UserDefaults.standard.set(mapView.region.span.longitudeDelta, forKey: "longitudeDelta")
        UserDefaults.standard.synchronize()
    }
    
    @objc func longPressGestureHandler(sender: UILongPressGestureRecognizer) {
         if sender.state != UIGestureRecognizer.State.began {
             return
         }
         let touchInput = sender.location(in: mapView)
         let location = mapView.convert(touchInput, toCoordinateFrom: mapView)
         let pin = addPin(location: location)
         addAnnotation(pin: pin)
     }
    
    // MARK: - Data Persistence
    func loadPins(){
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true)]
        if let result = try? dataContainer.viewContext.fetch(fetchRequest) {
            pins = result
            for pin in pins {
                addAnnotation(pin: pin)
            }
        }
    }
    
    // MARK: - Functions
    func addAnnotation(pin: Pin) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        mapView.addAnnotation(annotation)
    }
    
    func addPin(location: CLLocationCoordinate2D) -> Pin {
        let pin = Pin(context: dataContainer.viewContext)
        pin.latitude = location.latitude
        pin.longitude = location.longitude
        pins.append(pin)
        try? dataContainer.viewContext.save()
        return pin
    }
    
    func findPin(loc: CLLocationCoordinate2D) -> Pin? {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "latitude == %@ AND longitude == %@",
                                             NSNumber.init(value: loc.latitude),
                                             NSNumber.init(value: loc.longitude))
        
        if let result = try? dataContainer.viewContext.fetch(fetchRequest) {
            return result.first!
        } else {
            return nil
        }
    }
    
    // MARK: Segue to Photo Collection Controller
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "showPhotoCollection", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhotoCollectionViewController
        vc.pin = findPin(loc: mapView.selectedAnnotations.first!.coordinate)
        vc.dataContainer = dataContainer
    }
}
