//
//  PhotoAlbum+Extra.swift
//  VirtualTourist
//
//  Created by Timur Krüger on 05.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import UIKit
import CoreData

extension PhotoAlbumViewController: UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
     }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! PhotoCell
        
        cell.imageView.image = UIImage(named: "VirtualTourist_100")

        if let image = fetchedResultsController.object(at: indexPath).file {
            cell.imageView.image = UIImage(data: image)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dataContainer.viewContext.delete(self.fetchedResultsController.object(at: indexPath))
        try! self.dataContainer.viewContext.save()
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
        case .update:
            collectionView.reloadItems(at: [newIndexPath!])
        case .move:
            collectionView.moveItem(at: indexPath!, to: newIndexPath!)
        default:
            fatalError("Error, wrong operation type!")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            collectionView.insertSections(indexSet)
        case .delete:
            collectionView.deleteSections(indexSet)
        default:
            fatalError("Error, wrong indexSet!")
        }
    }
}
