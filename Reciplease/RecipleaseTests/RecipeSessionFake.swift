//
//  RecipeSessionFake.swift
//  RecipleaseTests
//
//  Created by Thomas on 16/09/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import Alamofire
@testable import Reciplease

class RecipeSessionFake: RecipeSession {
    
    private let fakeResponse: FakeResponse
    
    init(fakeResponse: FakeResponse) {
        self.fakeResponse = fakeResponse
    }
    
    override func request(url: URL, completionHandler: @escaping (AFDataResponse<Any>) -> Void) {
        
        guard let response = fakeResponse.response else {
            return
        }
        guard let data = fakeResponse.data else {
            completionHandler(.init(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0.0, result: .failure(.explicitlyCancelled)))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let object = try? JSONDecoder().decode(RecipeList.self, from: data)
        let result: Result<Any,AFError> = fakeResponse.error == nil ? .success(object as Any) : .failure(fakeResponse.error ?? AFError.explicitlyCancelled)
        
        let dataResponse = AFDataResponse(request: urlRequest, response: response, data: data, metrics: nil, serializationDuration: 0.0, result: result)
        completionHandler(dataResponse)
    }
    
}
