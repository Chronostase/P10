//
//  TestCoreDataManager.swift
//  RecipleaseTests
//
//  Created by Thomas on 14/10/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
@testable import Reciplease
import XCTest

class TestCoreDataManager: XCTestCase {
    var container: CoreDataManager!
    
    
    override func setUp() {
        super.setUp()
        container = CoreDataManager(container: CoreDataManagerFake().mockPersistantContainer)
    }
    
    
    func testSaveObjectShouldSucceed() {
        
        let object = try? JSONDecoder().decode(RecipeList.self, from: FakeResponseData().recipeCorrectData)
        
        guard let recipesArray = object?.hits else {
            return
        }
        var recipes: [RecipeDetails] = []
        
        for index in recipesArray {
            recipes.append(index.recipe)
            
            do {
                try container.saveObject(recipe: index.recipe, ingredientstext: "something")
            } catch {
                return 
            }
        }
        
        guard let result = container.read() else {
            return
        }
        print(result.count)
        XCTAssertEqual(result.count, 10)
        for recipe in result {
            try? container.remove(recipe: recipe)
        }
    }
    
//    func testShouldFailedIfReadIsEqualtoNil() {
//        let ccontainer = CoreDataManager(container: CoreDataManagerFake().mockPersistantContainer)
//        let object = try? JSONDecoder().decode(RecipeList.self, from: FakeResponseData().recipeCorrectData)
//
//        guard let recipesArray = object?.hits else {
//            return
//        }
//        var recipes: [RecipeDetails] = []
//
//        for index in recipesArray {
//            recipes.append(index.recipe)
//
//            do {
//                try ccontainer.saveObject(recipe: index.recipe, ingredientstext: "something")
//
//                let error = NSError()
//                throw error
//            } catch let error {
//                XCTAssertNotNil(error)
//                print("Oupsiii")
//            }
//        }
//
//        guard let result = ccontainer.read() else {
//            return
//        }
//        print(result.count)
//        XCTAssertEqual(result.count, 0)
//        for recipe in result {
//            container.remove(recipe: recipe)
//        }
//    }
    
    func testRemoveShouldWorkIfThereIsRecipeToRemove() {
        let object = try? JSONDecoder().decode(RecipeList.self, from: FakeResponseData().recipeCorrectData)
        
        guard let recipesArray = object?.hits else {
            return
        }
        var recipes: [RecipeDetails] = []
        
        for index in recipesArray {
            recipes.append(index.recipe)
            
            do {
                try container.saveObject(recipe: index.recipe, ingredientstext: "something")
            } catch {
                XCTAssertEqual(container.read()?.count, nil)
                print("Oupsiii")
            }
        }
        
        guard let result = container.read() else {
            return
        }
        print(result.count)
        XCTAssertEqual(result.count, 10)
        for recipe in result {
            try? container.remove(recipe: recipe)
        }
        XCTAssertEqual(container.read()?.count, 0)
    }
    
    func testRemoveShouldReturnIfThereIsNoChangeInViewContext() {
        XCTAssertEqual(container.read()?.count, 0)
        let recipe = Recipes()
        
        try? container.remove(recipe: recipe)
        
        XCTAssertEqual(container.read()?.count, 0)
    }
}
