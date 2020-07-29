//
//  FavoriteTableViewController.swift
//  Reciplease
//
//  Created by Thomas on 27/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import UIKit

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipes = coreDataManager.read()?.count else {
            return 0
        }
        return recipes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Enter TableView")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.identifier, for: indexPath) as? CustomTableViewCell else {
            print("failed 1")
            return UITableViewCell()
        }
        guard let recipes = coreDataManager.read() else {
            return UITableViewCell()
        }
        let recipe = recipes[indexPath.row]
        guard let name = recipe.name, let image = recipe.imageData else {
            print("failed 2")
            return UITableViewCell()
        }
        let ingredientList = "\(recipe.ingredientLines ?? "ops")"
        cell.configureCell(recipeImage: image, recipeName: name, recipeDetails: ingredientList, notationLabel: recipe.yield, durationLabel: recipe.totalTime)
        print("SuccessFully passed data")
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recipes = coreDataManager.read() else {
            return
        }
        let recipe = recipes[indexPath.row]
        pushRecipeDetail(withRecipe: recipe)
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
