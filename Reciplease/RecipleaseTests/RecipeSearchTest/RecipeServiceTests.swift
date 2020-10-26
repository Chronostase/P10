//
//  RecipeServiceTests.swift
//  RecipleaseTests
//
//  Created by Thomas on 16/09/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

@testable import Reciplease
import XCTest

class RecipeServiceTest: XCTestCase {
    var fakeResponseData: FakeResponse!
    var recipeService: RecipeService {
        return RecipeService(session: RecipeSessionFake(fakeResponse: fakeResponseData))
    }
    
    func testGetRecipeShouldGetFailedCallbackIfErrorAndIncorrectData() {
        // Given
        fakeResponseData = FakeResponse(response: FakeResponseData().responseOk, error: FakeResponseData.mokeError, data: FakeResponseData.recipeIncorrectData)
        //When
        recipeService.getData(userEntry: "chicken") { result in
            switch result {
            case .success(let recipeList):
                XCTAssertNil(recipeList)
                
            case .failure(let error):
                print(error)
                XCTAssertNotNil(error)
            }
        }
    }
//    
    func testGetRecipeShouldCallBackErrorIfBadResponseAndIncorrectData() {
        // Given
        fakeResponseData = FakeResponse(response: FakeResponseData().responseKo, error: FakeResponseData.mokeError, data: FakeResponseData.recipeIncorrectData)
        //When
        recipeService.getData(userEntry: "chicken") { result in
            switch result {
            case .success (let recipeList):
                XCTAssertNil(recipeList)
                
            case .failure(let error):
                print(error)
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testGetRecipeSouldFailedIfNoData() {
        fakeResponseData = FakeResponse(response: FakeResponseData().responseOk, error: FakeResponseData.mokeError, data: nil)
        
        recipeService.getData(userEntry: "chicken") { result in
            switch result {
            case .success(let recipeList):
                XCTAssertNil(recipeList)
                
            case .failure(let error) :
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testGetRecipeSouldGetSuccessIfCorrectDataResponseAndNoError() {
        fakeResponseData = FakeResponse(response: FakeResponseData().responseOk, error: nil, data: FakeResponseData().recipeCorrectData)
        
        recipeService.getData(userEntry: "chicken") { result in
            switch result {
            case .success(let recipeList):
                XCTAssertNotNil(recipeList)
                
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
}
