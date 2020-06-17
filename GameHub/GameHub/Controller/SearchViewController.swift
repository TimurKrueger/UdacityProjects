//
//  SearchViewController.swift
//  GameHub
//
//  Created by Timur Krüger on 08.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SearchViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var genrePicker: UIPickerView!
    @IBOutlet weak var searchByGenre: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var genreFields: [Genre] = [Genre]()
    var currentPickerField : Int = 0
    var foundGames: [Game] = [Game]()
    
    func setupGenreList(){
        genreFields.append(Genre(id: 15, name: "Strategy"))
        genreFields.append(Genre(id: 5, name: "Shooter"))
        genreFields.append(Genre(id: 14, name: "Sport"))
        genreFields.append(Genre(id: 33, name: "Arcade"))
        genreFields.append(Genre(id: 12, name: "RPG"))
        genreFields.append(Genre(id: 36, name: "Moba"))
        genreFields.append(Genre(id: 32, name: "Indie"))
        genreFields.append(Genre(id: 4, name: "Fighting"))
        genreFields.append(Genre(id: 10, name: "Racing"))
    }
    
    // MARK: - App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        genrePicker.delegate = self
        genrePicker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupGenreList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        foundGames.removeAll()
    }
    
    // MARK: - Text Field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        foundGames.removeAll()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activityIndicator.startAnimating()
        IGDBClient.getSearchResponse(gameName: textField.text!) { (data, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode([Game].self, from: data)
                    self.foundGames.append(contentsOf: responseObject)
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.performSegue(withIdentifier: "segueTableView", sender: self)
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
    
    // MARK: - Picker View Search
    @IBAction func searchWithFilters(_ sender: Any) {
        activityIndicator.startAnimating()
        IGDBClient.getSearchResponseByGenre(genreId: currentPickerField) { (data, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode([Game].self, from: data)
                    self.foundGames.append(contentsOf: responseObject)
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.performSegue(withIdentifier: "segueTableView", sender: self)
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
    }
    
    // MARK: - Picker View Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genreFields.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genreFields[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentPickerField = genreFields[row].self.id
    }
    
    // MARK: - Segue to Table View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTableView" {
            if let destinationVC = segue.destination as? DetailViewController {
                destinationVC.foundGames = foundGames
            }
        }
    }
}
