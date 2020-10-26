//
//  RecipeSession.swift
//  Reciplease
//
//  Created by Thomas on 09/09/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import Alamofire

class RecipeSession {
    
    func request(url: URL, completionHandler: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(url).validate().responseJSON { dataResponse in
            completionHandler(dataResponse)
        }
    }
    
}

