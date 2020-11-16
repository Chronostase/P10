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
    
    override func tearDown() {
        reset()
        super.tearDown()
    }
    
    private func reset() {
        guard let recipes = container.read() else {
            return
        }
        for recipe in recipes {
            try? container.remove(recipe: recipe)
        }
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
        XCTAssertEqual(result.count, 10)
    }
    
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
    
    func testRemoveShouldNotChangeIfThereIsNoChangeInViewContext() {
        XCTAssertEqual(container.read()?.count, 0)
        let recipe = Recipes()
        
        try? container.remove(recipe: recipe)
        
        XCTAssertEqual(container.read()?.count, 0)
    }
}
