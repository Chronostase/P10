//
//  RecipeListTableViewController.swift
//  Reciplease
//
//  Created by Thomas on 20/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import UIKit

extension RecipeListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipeCount = recipeList?.hits.count else {
            return 0
        }
        return recipeCount 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.identifier, for: indexPath) as? CustomTableViewCell,let recipe = recipeList?.hits[indexPath.row].recipe, let imageData = recipe.imageData, let notationImage = UIImage(named: "like"), let durationImage = UIImage(named: "watch") else {
            return UITableViewCell()
        }
        let recipeIngredients = recipe.ingredientLines[0]
        cell.configureCell(recipeImage: imageData, recipeName: recipe.label, recipeDetails: recipeIngredients, notationLabel: recipe.yield, durationLabel: recipe.totalTime, notationImage: notationImage, durationImage: durationImage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recipe = recipeList?.hits[indexPath.row].recipe else {
            return
        }
        pushRecipeDetail(withRecipe: recipe)
    }
}

extension RecipeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

