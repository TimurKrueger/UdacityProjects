//
//  DetailViewController.swift
//  GameHub
//
//  Created by Timur Krüger on 08.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UICollectionViewController {
    
    // MARK: - Properties
    var foundGames: [TestGame] = [TestGame]()
    var covers: [Covers] = [Covers]()
    var images: [CoverImages] = [CoverImages]()
    
    var blockOperation = BlockOperation()
    var dispatchGroup = DispatchGroup()
    
    // MARK: - App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupImages()
        self.collectionView.reloadData()
    }
    
    func setupImages() {
        let nameArrayLength = foundGames.count
        
        for index in 1..<nameArrayLength {
            IGDBClient.getCovers(gameId: foundGames[index].id) { (data, error) in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let responseObject = try decoder.decode([Covers].self, from: data)
                        self.covers.append(contentsOf: responseObject)

                        self.downloadCovers()
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    } catch {
                        DispatchQueue.main.async {
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Network error")
                    }
                }
                
            }
            self.collectionView.reloadData()
        }
    }
    
    func downloadCovers(){
        let nameArrayLength = covers.count
        for index in 1..<nameArrayLength {
            
            let string = covers[index].url
            
            let index_ = string.index(string.startIndex, offsetBy: 2)
            let mySubstring = "https://" + string.suffix(from: index_)
            print("My URL: ", mySubstring)
            
            let url = URL(string: String(mySubstring))!
            
            downloadImage(gameId: covers[index].game, from: url)
        }
    }
    
    func downloadImage(gameId: Int, from url: URL) {
        print("Download Started")
        
        IGDBClient.getData(from: url) { data, error in
            guard let data = data, error == nil else {
                return
            }
            print("Download Finished")
            
            DispatchQueue.main.async() { [weak self] in
                let temp: CoverImages = CoverImages(id: gameId, image: UIImage(data: data))
                self?.images.append(temp)
            }
        }
    }
    
    // MARK: - Collection View Delegate
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foundGames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionCell
        print("Count games: ",foundGames.count)
        print("Count images: ", images.count)
        
        let game = self.foundGames[indexPath.item]
        cell.cellName.text = game.name
        
        if(images.count != 0){
            for index in 1..<images.count {
                if(foundGames[indexPath.item].id == images[index].id) {
                    let gameCover = self.images[index]
                    cell.cellImageView.image = gameCover.image
                }
            }
        }
        return cell
    }
    
    @IBAction func debug_(_ sender: Any) {
        for (index, element) in foundGames.enumerated() {
            print("Item \(index): \(element)")
        }
        
        for (index, element) in covers.enumerated() {
            print("Item \(index): \(element)")
        }
        
        for(index, element) in images.enumerated() {
            print("Item \(index): \(element)")
        }
    }
}
