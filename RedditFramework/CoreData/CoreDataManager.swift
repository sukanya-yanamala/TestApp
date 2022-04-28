//
//  CoreDataManager.swift
//  RedditChallenge
//
//  Created by Sukanya Yanamala on 4/5/22.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    var mainContext: NSManagedObjectContext { get }
}

class CoreDataManager: CoreDataManagerProtocol {
    
    var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RedditChallenge")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
}
