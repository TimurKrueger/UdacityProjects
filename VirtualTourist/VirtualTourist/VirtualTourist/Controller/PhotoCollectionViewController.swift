//
//  PhotoCollectionViewController.swift
//  VirtualTourist
//
//  Created by Timur Krüger on 07.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoCollectionViewController: UIViewController, UICollectionViewDataSource, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, MKMapViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var noPicture: UILabel!
    @IBOutlet weak var newCollection: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailView: UIImageView!
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var dataContainer: DataContainer!
    var pin: Pin!
    var numberOfPhotos = 0
    var list: [FlickrPhoto] = []
    
    var blockOperation = BlockOperation()
    var dispatchGroup = DispatchGroup()
    
    // MARK: - App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        setupFetchedResultsController()

        let startingCoordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        let startingSpan = MKCoordinateSpan.init(latitudeDelta: 0.3, longitudeDelta: 0.3)
        
        var mapRegion = MKCoordinateRegion(center: startingCoordinate, span: startingSpan)
        mapRegion.center = startingCoordinate
        mapView.setRegion(mapRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = startingCoordinate
        mapView.addAnnotation(annotation)
        mapView.centerCoordinate = startingCoordinate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialSetup()
        if pin.photo?.count == 0 {
            fetchPictureFromPin(pin: pin)
        } else {
            newCollection.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    func initialSetup() {
        noPicture.isHidden = true
        newCollection.isHidden = true
    }
    
    // MARK: - Data Persistence
    @IBAction func newCollection(_ sender: Any) {
        if let photos = fetchedResultsController.fetchedObjects {
            for photo in photos {
                self.dataContainer.viewContext.delete(photo)
                try? self.dataContainer.viewContext.save()
            }
        }
        fetchPictureFromPin(pin: pin)
    }
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pin", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataContainer.viewContext, sectionNameKeyPath: nil, cacheName: "\(String(describing: pin))-photos")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func fetchPictureFromPin(pin: Pin) {
        initialSetup()
        FlickrClient.getSearchResult(pin: pin) { (list, error) in
            self.numberOfPhotos = list?.count ?? 0
            print(self.numberOfPhotos)
            self.downloadPictures(list: list!, pin: pin)
            DispatchQueue.main.async {
                if list?.count == 0 {
                    self.noPicture.isHidden = false
                }
                self.dispatchGroup.notify(queue: .main) {
                    self.newCollection.isHidden = false
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    func downloadPictures(list: [FlickrPhoto], pin: Pin) {
        for item in list {
            guard let imageURL = URL(string: item.url_n) else {
                return
            }
            FlickrClient.downloadPicture(imageURL: imageURL, pin: pin, completion: downloadFromData)
        }
    }
    
    func downloadFromData(data: Data?, error: Error?) {
        dispatchGroup.enter()
        let photo = Photo(context: self.dataContainer.viewContext)
        photo.file = data
        photo.pin = self.pin
        try? self.dataContainer.viewContext.save()
        dispatchGroup.leave()
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionCell
        cell.imageView.image = UIImage(named: "VirtualTourist_120")
        
        if let image = fetchedResultsController.object(at: indexPath).file {
            cell.imageView.image = UIImage(data: image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dataContainer.viewContext.delete(self.fetchedResultsController.object(at: indexPath))
        try! self.dataContainer.viewContext.save()
    }
}
