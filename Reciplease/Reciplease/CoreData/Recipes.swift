//
//  Recipes.swift
//  Reciplease
//
//  Created by Thomas on 29/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import CoreData

class Recipes: NSManagedObject {
    
    var convertedToRecipeDetails: RecipeDetails? {
        guard let name = self.name, let image = self.image, let imageData = self.imageData, let ingredientLines = self.ingredientLines, let url = self.url else {
            return nil
        }
        let recipe = RecipeDetails(label: name, image: image, url: url, yield: self.yield, ingredientLines: [ingredientLines], totalTime: self.totalTime, imageData: imageData)
        return recipe
    }
}
