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
    
    var container: NSPersistentContainer?
    
    init(container: NSPersistentContainer = NSPersistentContainer(name: Constants.ControllerName.reciplease)) {
        self.container = container
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        container = NSPersistentContainer(name: Constants.ControllerName.reciplease)
        container?.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? { fatalError("Unresolved error \(error), \(error.userInfo)") }
        })

        guard let persistentContainer = container else { return NSPersistentContainer() }
        return persistentContainer
    }()
    
    // MARK: - Core Data Saving support
    
    /**Use to save a Recipe in CoreData*/
    func saveObject(recipe: RecipeDetails, ingredientstext: String) throws  {
        
        let favoriteRecipe = Recipes(context: self.persistentContainer.viewContext)
        favoriteRecipe.name = recipe.label
        favoriteRecipe.ingredientLines = ingredientstext
        favoriteRecipe.image = recipe.image
        favoriteRecipe.totalTime = recipe.totalTime
        favoriteRecipe.yield = recipe.yield
        favoriteRecipe.imageData = recipe.imageData
        favoriteRecipe.url = recipe.url
        do {
            try self.persistentContainer.viewContext.save()
        }
        catch let error { throw error }
    }
    
    private func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do { try context.save()}
            catch let error { throw error }
        }
    }
    
    func read()-> [Recipes]? {
        let request: NSFetchRequest<Recipes> = Recipes.fetchRequest()
         
        do {
            let recipes = try persistentContainer.viewContext.fetch(request)
            return recipes
        } catch  { return nil }
    }
    
    func remove(recipe: Recipes) throws  {
        persistentContainer.viewContext.delete(recipe)
        guard persistentContainer.viewContext.hasChanges else {
            return 
        }
        do {
            try persistentContainer.viewContext.save()
            
        } catch let error  { throw error }
    }
}

