//
//  FakeResponseData.swift
//  RecipleaseTests
//
//  Created by Thomas on 16/09/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import Alamofire

class FakeResponseData {
    
    var recipeCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "SearchRecipe", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let mokeError = AFError.explicitlyCancelled
    static let recipeIncorrectData = "Incorrect Data".data(using: .utf8)
    
    
    let responseOk = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    let responseKo = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
}
