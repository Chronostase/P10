//
//  ApiKey.swift
//  Reciplease
//
//  Created by Thomas on 14/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation

class ApiKeys {
    
    static func value(for key: String) -> String? {
        guard let apiKeysPlist = Bundle.main.path(forResource: "ApiKeys",ofType: "plist"),
            let keys = NSDictionary(contentsOfFile: apiKeysPlist),
            let key = keys[key] as? String else {
                return nil
        }
        
        return key
    }
}
