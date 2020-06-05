//
//  MemeCollectionViewController.swift
//  MemeMeApp 2.0
//
//  Created by Timur Krüger on 26.03.20.
//  Copyright © 2020 Yumeda. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    private let reuseIdentifier = "SentMemesCollectionViewCell"
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: - App Lifecycle
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (collectionView.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue Cells with reuseIdentifier with custom class CollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SentMemesCollectionViewCell
        
        // Get Meme from array
        let meme = self.memes[indexPath.item]
        
        // Set attributes of cell
        cell.imageView?.image = meme.memedImage
        
        // Return Cell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "SentMemesDetailViewController") as! SentMemesDetailViewController
        
        // Set meme in DetailVC from current tapped meme
        detailController.meme = ((UIApplication.shared.delegate as! AppDelegate).memes[indexPath.row])
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
    }
}
