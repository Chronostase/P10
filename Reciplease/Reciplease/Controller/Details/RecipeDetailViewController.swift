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
    
    @IBOutlet var navItem: UINavigationItem!
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
    
    @IBAction func getDirectionButton(_ sender: UIButton) {
        showWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupNavigationBarButton()
        setNavigationBarTitle(title: "Reciplease", navItem: navItem)
//        setFavoriteButtonColor()
    }
    
    /** Show recipe webPage */
    private func showWebView() {
        guard let recipeUrl = recipe?.url, let url = URL(string: recipeUrl) else {
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
    /** Set image, recipeName and ingredientDetail */
    private func setupUIForRecipe () {
        guard let imageData = recipe?.imageData, let recipe = recipe else {
            return
        }
        let image = UIImage(data: imageData)
        recipeName.text = recipe.label
        recipeImage.image = image
        var recipeIngredients = ""
        for element in recipe.ingredientLines {
            //Problème duplique tiret
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
    
    
    /** Add Favorite button to navigationBar*/
    private func setupNavigationBarButton() {
        let button = UIButton(type: .custom)
        guard let image = UIImage(named: "star") else {
            return
        }
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        let rightButton = UIBarButtonItem(customView: button)
        
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc private func addToFavorite(button: UIButton) {
        if button.tintColor == UIColor.white {
            button.tintColor = .systemYellow
            saveObject()
        } else {
            removeRecipe()
        }
    }
    
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
    
    private func setFavoriteButtonColor() {
        if isAlreadyInFavorite() {
            navigationItem.rightBarButtonItem?.customView?.tintColor = .systemYellow
        } else {
            navigationItem.rightBarButtonItem?.customView?.tintColor = .white
        }
    }
    
    private func isAlreadyInFavorite() -> Bool {
        var indicator = false
        guard let favoriteRecipes = coreDataManager.read() else {
            return false
        }
//        favoriteRecipes.first { $0.name == recipeName.text }
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
    
    private func saveObject() {
        print("Enter in saveObject")
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
            print("SuccessFully save")
        } catch {
            displayAlert(message: "Can't save recipe")
        }
    }
}
