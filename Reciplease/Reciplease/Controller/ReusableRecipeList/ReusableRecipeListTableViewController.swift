//
//  ReusableRecipeListTableViewController.swift
//  Reciplease
//
//  Created by Thomas on 03/11/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import UIKit

extension ReusableRecipeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch dataSourceType {
        case .api:
            
            guard let recipeCount = recipelist?.hits.count else {
                return 0
            }
            return recipeCount
            
        case .coreData:
            
            guard let recipes = coreDataManager.read()?.count else {
                return 0
            }
            return recipes
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        switch dataSourceType {
        case .api:
            
            guard let recipeDetails = recipelist?.hits[indexPath.row].recipe else {
                return UITableViewCell()
            }
            cell.configureCell(recipe: recipeDetails)
            return cell
        case .coreData:
            
            guard let recipes = coreDataManager.read() else {
                return UITableViewCell()
            }
            guard let recipe = recipes[indexPath.row].convertedToRecipeDetails else {
                return UITableViewCell()
            }
            cell.configureCell(recipe: recipe)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showIndicator()
        
        switch dataSourceType {
        case .api:
            
            guard let recipe = recipelist?.hits[indexPath.row].recipe else {
                return
            }
            self.hideIndicator()
            pushRecipeDetail(withRecipe: recipe, indexPath: indexPath)
            
        case .coreData:
            
            guard let recipes = coreDataManager.read(), let recipe = recipes[indexPath.row].convertedToRecipeDetails else {
                return
            }
            self.hideIndicator()
            pushRecipeDetail(withRecipe: recipe)
        }
    }
    
    // Find a way to only use this method in FavoritePage
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard dataSourceType == .coreData else {
            return nil
        }
        let deletAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            guard let recipes = self.coreDataManager.read() else {
                return
            }
            for recipe in recipes {
                print(recipe.name as Any)
            }
            let recipe = recipes[indexPath.row]
            try? self.coreDataManager.remove(recipe: recipe)
            tableView.reloadData()
            self.showPlaceholderView()
            for recipe in recipes {
                print(recipe.name as Any)
            }
            
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deletAction])
    }
}
extension ReusableRecipeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
}
