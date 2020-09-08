//
//  DataManager.swift
//  Reciplease
//
//  Created by Thomas on 27/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.ControllerName.reciplease)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func read() -> [Recipes]? {
        let request: NSFetchRequest<Recipes> = Recipes.fetchRequest()
         
        do {
            let recipes = try persistentContainer.viewContext.fetch(request)
            return recipes
        } catch {
            return nil
        }
    }
    
    func remove(recipe: Recipes) {
        persistentContainer.viewContext.delete(recipe)
        guard persistentContainer.viewContext.hasChanges else {
            return 
        }
        saveContext()
    }
}

