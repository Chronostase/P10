//
//  DoubleExtension.swift
//  Reciplease
//
//  Created by Thomas on 12/08/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation

extension Double {
    
    var convertMinutesInHours: String {
        let minutes = self
        var value = ""
        if minutes < 60 {
            return "\(Int(minutes))m"
        } else if minutes/60 >= 1 {
            let newValue = String("\(Int(minutes)/60)h")
            value = newValue
        }
        return value
    }
}
