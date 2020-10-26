//
//  Recipe.swift
//  Reciplease
//
//  Created by Thomas on 17/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
//import CoreData

struct RecipeList: Decodable {
    var hits: [Hit]
}

struct Hit: Decodable {
    var recipe: RecipeDetails
}

struct RecipeDetails: Decodable {
    var label: String
    var image: String
    var url: String
    var yield: Double
    var ingredientLines: [String]
    var totalTime: Double
    var imageData: Data?
    
}
