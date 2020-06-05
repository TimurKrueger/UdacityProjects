//
//  MemeDetailViewController.swift
//  MemeMeApp 2.0
//
//  Created by Timur Krüger on 25.03.20.
//  Copyright © 2020 Yumeda. All rights reserved.
//

import UIKit

class SentMemesDetailViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!
    
    // MARK: - App Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.imageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
