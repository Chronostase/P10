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
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        let values = ["key": "value"]
        request.httpBody = try! JSONSerialization.data(withJSONObject: values, options: [])
        AF.request(request as URLRequestConvertible).validate().responseJSON { (dataResponse) in
            completionHandler(dataResponse)
        }
    }
    
}

