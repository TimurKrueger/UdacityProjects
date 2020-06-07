//
//  DataContainer.swift
//  VirtualTourist
//
//  Created by Timur Krüger on 05.06.20.
//  Copyright © 2020 Timur. All rights reserved.
//

import CoreData

class DataContainer {
    
    var container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    init(containerName: String) {
        container = NSPersistentContainer(name: containerName)
    }
    
    func load(handler: (()->Void)?=nil) {
        container.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            handler?()
        }
    }
}
