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
        if dataSourceType == .api {
            guard let recipeCount = recipelist?.hits.count else {
                return 0
            }
            return recipeCount
        } else if dataSourceType == .coreData {
            
            guard let recipes = coreDataManager.read()?.count else {
                return 0
            }
            return recipes
        }
        return 0
    }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.identifier, for: indexPath) as? CustomTableViewCell else {
                return UITableViewCell()
            }
            if dataSourceType == .api {
                guard let recipeDetails = recipelist?.hits[indexPath.row].recipe else {
                    return UITableViewCell()
                }
                cell.configureCell(recipe: recipeDetails)
            } else if dataSourceType == .coreData {
                guard let recipes = coreDataManager.read() else {
                    return UITableViewCell()
                }
                guard let recipe = recipes[indexPath.row].convertedToRecipeDetails else {
                    return UITableViewCell()
                }
                cell.configureCell(recipe: recipe)
            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.showIndicator()
            if dataSourceType == .api {
                guard let recipe = recipelist?.hits[indexPath.row].recipe else {
                    return
                }
                self.hideIndicator()
                pushRecipeDetail(withRecipe: recipe, indexPath: indexPath)
            } else if dataSourceType == .coreData {
                guard let recipes = coreDataManager.read(), let recipe = recipes[indexPath.row].convertedToRecipeDetails else {
                    return
                }
                self.hideIndicator()
                pushRecipeDetail(withRecipe: recipe)
            }
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if dataSourceType == .coreData {
                if editingStyle == UITableViewCell.EditingStyle.delete {
                    guard let recipes = coreDataManager.read() else {
                        return
                    }
                    for recipe in recipes {
                        print(recipe.name as Any)
                    }
                    let recipe = recipes[indexPath.row]
                    try? coreDataManager.remove(recipe: recipe)
                    tableView.reloadData()
                    showPlaceholderView()
                    for recipe in recipes {
                        print(recipe.name as Any)
                    }
                }
            }
        }
    }

    extension ReusableRecipeListViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
            return 150
        }
}
