//
//  RecipeService.swift
//  Reciplease
//
//  Created by Thomas on 17/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import Alamofire

class RecipeService {
    
    func getData(userEntry: String, callback: @escaping (Result <RecipeList?, ServiceError>) -> Void) {
            AF.request(createURLRequest(userEntry) , method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
                (responseData) in
                guard responseData.error == nil else {
                    callback(.failure(.error))
                    return
                }
                guard let response = responseData.response else {
                    callback(.failure(.badResponse))
                    return
                }
                guard 200..<300 ~= response.statusCode else {
                    callback(.failure(.invalidStatusCode(statusCode: response.statusCode)))
                    return
                }
                guard let data = responseData.data else {
                    callback(.failure(.dataError))
                    return
                }
                
                do {

                    let object = try JSONDecoder().decode(RecipeList.self, from: data)
                    callback(.success(object))
                } catch {
                    print(error)
                    callback(.failure(.decodingError))
                }
                
            }
        }
    
    private func createURLRequest(_ userEntry: String) -> String {
        guard let appId = ApiKeys.value(for: Constants.AppIdAndKey.recipeSearchId), let appKey = ApiKeys.value(for: Constants.AppIdAndKey.recipeSearchKey) else {
            return ""
        }
        let url = Constants.Service.baseUrl + userEntry + Constants.Service.idParameter + appId + Constants.Service.keyParameter + appKey
        print(url)
        
        return url
    }
}
