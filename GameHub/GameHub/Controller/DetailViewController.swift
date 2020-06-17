//
//  DetailViewController.swift
//  GameHub
//
//  Created by Timur Krüger on 08.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UITableViewController {
    
    // MARK: - Properties
    var foundGames: [Game] = [Game]()
    var coverUrl: [CoverURL] = [CoverURL]()
    var images: [CoverImages] = [CoverImages]()
    
    // MARK: - App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupImages()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        foundGames.removeAll()
        coverUrl.removeAll()
        images.removeAll()
    }
    
    func setupImages() {
        let nameArrayLength = foundGames.count
        if(nameArrayLength != 0) {
            for index in 1..<nameArrayLength {
                IGDBClient.getCovers(gameId: foundGames[index].id) { (data, error) in
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let responseObject = try decoder.decode([CoverURL].self, from: data)
                            self.coverUrl.append(contentsOf: responseObject)
                            self.downloadCoverImages()
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
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
                self.tableView.reloadData()
            }
        }
        self.tableView.reloadData()
    }
    
    func downloadCoverImages(){
        let nameArrayLength = coverUrl.count
        if(nameArrayLength != 0){
            for index in 1..<nameArrayLength {
                let string = coverUrl[index].url
                let index_ = string.index(string.startIndex, offsetBy: 2)
                let mySubstring = "https://" + string.suffix(from: index_)
                
                let url = URL(string: String(mySubstring))!
                downloadImage(gameId: coverUrl[index].game, from: url)
            }
        }
    }
    
    func downloadImage(gameId: Int, from url: URL) {
        IGDBClient.getData(from: url) { data, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let temp: CoverImages = CoverImages(id: gameId, image: UIImage(data: data))
                self.images.append(temp)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundGames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as! CollectionCell
        
        let game = self.foundGames[indexPath.item]
        cell.cellName.text = game.name
        
        let popularity = Double(round(1000 * game.popularity) / 1000)
        cell.cellPopularity.text = "Popularity: " + String(popularity)
        
        if(images.count != 0){
            for index in 1..<images.count {
                if(foundGames[indexPath.item].id == images[index].id) {
                    DispatchQueue.main.async {
                        let gameCover = self.images[index]
                        cell.cellImageView.image = gameCover.image
                    }
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Save Game", message: "Do you want to add \"\(foundGames[indexPath.item].name)\" to the favourite list?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.saveGameToFavourites(game: self.foundGames[indexPath.item])
            
            DispatchQueue.main.async {
                let alertTwo = UIAlertController(title: "Success adding game.", message: "", preferredStyle: .alert)
                alertTwo.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
                    return
                }))
                
                DispatchQueue.main.async {
                    self.present(alertTwo, animated: true)
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            return
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Data Persistence
    func saveGameToFavourites(game: Game) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ListGameObject", in: managedContext)!
        let saveGame = NSManagedObject(entity: entity, insertInto: managedContext)
        
        saveGame.setValue(game.id, forKeyPath: "id")
        saveGame.setValue(game.name, forKeyPath: "name")
        saveGame.setValue(game.popularity, forKeyPath: "popularity")
        saveGame.setValue(game.url, forKeyPath: "url")
        
        do {
            try managedContext.save()
            print("Saving game: \(game.name)!")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
