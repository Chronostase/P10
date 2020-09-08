//
//  RecipeDetails.swift
//  Reciplease
//
//  Created by Thomas on 22/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet var starButton: UIBarButtonItem!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var recipeName: UILabel!
    
    let coreDataManager = CoreDataManager()
    var recipe: RecipeDetails? {
        didSet {
            DispatchQueue.main.async {
                self.setupUIForRecipe()
            }
        }
    }
    @IBAction func starBoutton(_ sender: UIBarButtonItem) {
        addOrRemoveFavorite(button: sender)
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        popViewController()
    }
    
    @IBAction func getDirectionButton(_ sender: UIButton) {
        showWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    /** Set image, recipeName and ingredientDetail */
    private func setupUIForRecipe () {
        guard let recipe = recipe, let data = recipe.imageData else {
            return
        }
        recipeName.text = recipe.label
        recipeImage.image = UIImage(data: data)
        var recipeIngredients = ""
        for element in recipe.ingredientLines {
            if element.first == "-" {
                recipeIngredients.append((element + "*").formattedArrayToReading)
            } else {
                recipeIngredients.append(("- " + element + "*").formattedArrayToReading)
            }
            print(recipeIngredients)
        }
        ingredientsTextView.text = recipeIngredients
        setFavoriteButtonColor()
    }
    
    /**
     Serve to add recipe in favorite if button.tintColor == .white else remove to favorite
     - Parameter button: is use to check starButton Color
     */
    private func addOrRemoveFavorite(button: UIBarButtonItem) {
        if button.tintColor == UIColor.white {
            button.tintColor = .systemYellow
            saveObject()
        } else {
            removeRecipe()
        }
    }
    /**
     Fetch recipe save in coreData, check if currentRecipe.Name == dataFetch.name if it's True remove current recipe from CoreData
     */
    private func removeRecipe() {
        guard let favoriteRecipes = coreDataManager.read() else {
            return
        }
        if favoriteRecipes.count > 0 {
            for recipe in favoriteRecipes {
                if recipe.name == recipeName.text {
                    coreDataManager.remove(recipe: recipe)
                }
            }
        }
        setFavoriteButtonColor()
    }
    /**Check if recipe is alreadyInFavorite if True change starButton.tintColor to Yellow, if it's False starButton.tintColor == .white*/
    private func setFavoriteButtonColor() {
        if isAlreadyInFavorite() {
            starButton.tintColor = .systemYellow
        } else {
            starButton.tintColor = .white
        }
    }
    /**Fetch recipe from CoreData check if currentRecipe.Name == dataFetch.name if true return true else return false*/
    private func isAlreadyInFavorite() -> Bool {
        var indicator = false
        guard let favoriteRecipes = coreDataManager.read() else {
            return false
        }
        if favoriteRecipes.count > 0 {
            for recipe in favoriteRecipes {
                // Try to compare complete recipe
                if recipe.name == recipeName.text {
                    indicator = true
                }
            }
        }
        return indicator
    }
    
    /** Made disappear current ViewController */
    private func popViewController() {
            self.navigationController?.popViewController(animated: true)
    }
    
    /** Show recipe webPage */
    private func showWebView() {
        guard let recipeUrl = recipe?.url, let url = URL(string: recipeUrl) else {
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
    
    /**Use to save a Recipe in CoreData*/
    private func saveObject() {
        guard let recipe = self.recipe else {
            return
        }
        let favoriteRecipe = Recipes(context: coreDataManager.persistentContainer.viewContext)
        favoriteRecipe.name = recipe.label
        favoriteRecipe.ingredientLines = self.ingredientsTextView.text
        favoriteRecipe.image = recipe.image
        favoriteRecipe.totalTime = recipe.totalTime
        favoriteRecipe.yield = recipe.yield
        favoriteRecipe.imageData = recipe.imageData
        favoriteRecipe.url = recipe.url
        do {
            try coreDataManager.persistentContainer.viewContext.save()
        } catch {
            displayAlert(message: Constants.CoreDataError.saveError )
        }
    }
}
