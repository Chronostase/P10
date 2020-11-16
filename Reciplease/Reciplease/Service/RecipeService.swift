//
//  RecipeService.swift
//  Reciplease
//
//  Created by Thomas on 17/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.

import Foundation
import Alamofire

class RecipeService {
    
    // MARK: - Properties
    private let session: RecipeSession
    
    // MARK: - Methods
    init(session: RecipeSession = RecipeSession()) {
        self.session = session
    }
    
    func getData(userEntry: String, callback: @escaping (Result <RecipeList?, AFError>) -> Void) {
        
        guard let url = createURL(userEntry) else { return }
        
        session.request(url: url) { result in
            guard let data = result.data else {
                callback(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            do {
                
                let object = try JSONDecoder().decode(RecipeList.self, from: data)
                callback(.success(object))
            } catch {
                callback(.failure(AFError.explicitlyCancelled))
            }
        }
    }
    
    private func createURL(_ userEntry: String) -> URL? {
        guard let appId = ApiKeys.value(for: Constants.AppIdAndKey.recipeSearchId), let appKey = ApiKeys.value(for: Constants.AppIdAndKey.recipeSearchKey) else {
            return nil
        }
        let stringUrl = Constants.Service.baseUrl + userEntry + Constants.Service.idParameter + appId + Constants.Service.keyParameter + appKey
        print(stringUrl)
        
        return URL(string: stringUrl)
    }
}
