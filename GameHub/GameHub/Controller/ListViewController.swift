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
    
    // MARK: - Properties
    @IBOutlet weak var listView: UITableView!
    var games: [NSManagedObject] = []
    
    // MARK: - App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListGameObject")
        
        do {
            games = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            self.showAlert(message: "Could not fetch! \(error.localizedDescription)")
        }
        listView.reloadData()
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = games[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListCell
        
        cell.cellName.text = game.value(forKeyPath: "name") as? String
        
        let gamePopularity = game.value(forKey: "popularity") as! Double
        let popularity = Double(round(1000 * gamePopularity) / 1000)
        
        cell.cellPopularity.text = "Popularity: \(String(popularity))"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Share Game", message: "Visit the website of the game or share it with your friends.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { action in
            self.shareGame(index: indexPath)
        }))
        
        alert.addAction(UIAlertAction(title: "Visit", style: .default, handler: { action in
            self.visitWebsite(index: indexPath)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.dismiss(animated: true)
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            let commit = games[indexPath.row]
            context.delete(commit)
            games.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            try! context.save()
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Website Action
    func visitWebsite(index: IndexPath) {
        let game = games[index.row]
        let url = game.value(forKey: "url") as? String
        UIApplication.shared.open(URL(string: url!)!, options: [:], completionHandler: nil)
    }
    
    func shareGame(index: IndexPath) {
        let game = games[index.row]
        let url = game.value(forKey: "url") as? String
        let activityViewController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed {
                // Todo - Test Message send on real phone
                print("success")
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - User Response Alert
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error Message", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
