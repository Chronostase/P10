//
//  CoreDataManagerFake.swift
//  RecipleaseTests
//
//  Created by Thomas on 13/10/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import CoreData
@testable import Reciplease

class CoreDataManagerFake: CoreDataManager {

    var coreDataManager: CoreDataManager!
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: Constants.ControllerName.reciplease, managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            
            precondition( description.type == NSInMemoryStoreType )
                                        
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    lazy var failPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer()
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            
            if let error = error {
                fatalError("create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()

}
