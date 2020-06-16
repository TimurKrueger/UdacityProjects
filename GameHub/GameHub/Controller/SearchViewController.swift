//
//  SearchViewController.swift
//  GameHub
//
//  Created by Timur Krüger on 08.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var searchView: UICollectionView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    
    var genres: [Genre] = [Genre]()
    var foundGames: [TestGame] = [TestGame]()
    
    // MARK: - App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //pickerView.delegate = self
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        IGDBClient.getGenres { (data, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode([Genre].self, from: data)
                    self.genres.append(contentsOf: responseObject)
                    
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
        searchView.reloadData()
    }
    
    // MARK: - Text Field Delegate
    @IBOutlet weak var searchTextField: UITextField!
    var search: String = ""
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        foundGames.removeAll()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search = textField.text!
        IGDBClient.getSearchResponse(gameName: search) { (data, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode([TestGame].self, from: data)
                    self.foundGames.append(contentsOf: responseObject)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "segueCollectionView", sender: self)
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
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCollectionView" {
            if let destinationVC = segue.destination as? DetailViewController {
                destinationVC.foundGames = foundGames
            }
        }
    }
}
