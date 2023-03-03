//
//  CoreDataManager.swift
//  ToWatch
//
//  Created by Sharma McGavin on 03/03/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    
    private init() {
        
        
        persistentContainer = NSPersistentContainer(name: "ToWatchModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
    }
}
