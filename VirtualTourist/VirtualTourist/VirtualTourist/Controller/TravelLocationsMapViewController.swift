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
    
    @IBOutlet weak var mapView: MKMapView!
    var selectedAnnotation: MKAnnotation!
    let dataContainer = DataContainer(containerName: "VirtualTourist")
    var pins: [Pin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataContainer.load()
        
        mapView.delegate = self
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressHandler(sender:)))
        
        mapView.addGestureRecognizer(longPress)
    }
    
    // MARK: Annotations and Pin functions
    @objc func longPressHandler(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began { return }
        let touchInput = sender.location(in: mapView)
        let location = mapView.convert(touchInput, toCoordinateFrom: mapView)
        let pin = addPin(location: location)
        addAnnotation(pin: pin)
    }
    
    func addAnnotation(pin: Pin){
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lat", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "lat == %@ AND lon == %@",
                                             NSNumber.init(value: loc.latitude),
                                             NSNumber.init(value: loc.longitude))
        
        if let result = try? dataContainer.viewContext.fetch(fetchRequest) {
            return result.first!
        } else {
            return nil
        }
    }
    
    // MARK: Segue to Photo Album Controller
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "showPhotoAlbum", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhotoAlbumViewController
        vc.dataContainer = dataContainer
    }
}
