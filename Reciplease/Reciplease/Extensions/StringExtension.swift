//
//  StringExtension.swift
//  Reciplease
//
//  Created by Thomas on 21/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation

extension String {
    
    var formattedToRequest: String {
        let characterModification = [" ": "%20", "-": "", "\n": ""]
        var formattedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
        characterModification.forEach {formattedText = formattedText.replacingOccurrences(of: $0.key, with: $0.value)}
        return formattedText
    }
    
    var formattedToReading: String {
        var formattedText = self
        let characterModification = ["[": "","]": "","\"": ""]
        characterModification.forEach { formattedText = formattedText.replacingOccurrences(of: $0.key, with: $0.value) }
        return formattedText
        }
}
