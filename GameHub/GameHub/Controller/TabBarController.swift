//
//  TabBarController.swift
//  GameHub
//
//  Created by Timur Krüger on 10.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TabBarController: UITabBarController {
    
    @IBOutlet weak var addGame: UIBarButtonItem!
    
    /*var games: [NSManagedObject] = []
    
    @IBAction func addGame(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name",  message: "Add a new Game", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.save(name: nameToSave)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Game", in: managedContext)!
        
        let game = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        game.setValue(name, forKeyPath: "name")
        
        // 4
        do {
            try managedContext.save()
            games.append(game)
            print("Saving game \(name)")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    
    var sharedGame = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sharedGame.name = "Starcraft"
        sharedGame.id = 123
        sharedGame.popularity = 1.2
        sharedGame.url = "https://blizzard.com"
        sharedGame.genre = "strategy"
    }
    
    // MARK: - Activity View Controller
    @IBAction func shareGame(_ sender: Any) {
        
        let activityViewController = UIActivityViewController(activityItems: [sharedGame], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed {
                print("success")
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    */
}
