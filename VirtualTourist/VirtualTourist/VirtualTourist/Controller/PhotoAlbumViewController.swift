//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Timur Krüger on 05.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var noPicture: UITextView!
    @IBOutlet weak var newCollection: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var dataContainer: DataContainer!
    var pin: Pin!
    var numberOfPhotos = 0
    var list: [FlickrPhoto] = []
    
    weak var delegate: CollectionViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

protocol CollectionViewDelegate: class {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}
