//
//  ListViewController.swift
//  GameHub
//
//  Created by Timur Krüger on 08.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    @IBOutlet weak var listView: UITableView!
    //var games: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.register(UITableViewCell.self, forCellReuseIdentifier: "listCell")
        listView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //1
       /* guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Game")
        
        //3
        do {
            games = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        */
        listView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return games.count
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let game = games[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        //cell.textLabel?.text = game.value(forKeyPath: "name") as? String
        return cell
    }
}
