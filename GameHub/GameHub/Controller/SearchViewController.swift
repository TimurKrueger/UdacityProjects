//
//  SearchViewController.swift
//  GameHub
//
//  Created by Timur Krüger on 08.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = ""
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
        
        cell.cellImageView.image = UIImage()
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        // Set meme in DetailVC from current tapped meme
        
        self.dataContainer.viewContext.delete(self.fetchedResultsController.object(at: indexPath))
        try! self.dataContainer.viewContext.save()
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
    }
    
}
