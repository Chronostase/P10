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
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var recipeName: UILabel!
    
    let coreDataManager = CoreDataManager()
    var recipe: RecipeDetails?
    var recipes: [Recipes]?
    
    @IBAction func getDirectionButton(_ sender: UIButton) {
        showWebView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBarButton()
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
    private func setupUI () {
        guard let imageData = recipe?.imageData else {
            return
        }
        let image = UIImage(data: imageData)
        recipeName.text = recipe?.label
        recipeImage.image = image
        ingredientsTextView.text = "\(recipe?.ingredientLines ?? [""])".formattedToReading
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
        button.tintColor = .systemYellow
        saveObject()
    }
    
    private func saveObject() {
        print("Enter in saveObject")
        guard let recipe = self.recipe else {
            return
        }
        let favoriteRecipe = Recipes(context: coreDataManager.persistentContainer.viewContext)
        favoriteRecipe.name = recipe.label
        favoriteRecipe.ingredientLines = "\(recipe.ingredientLines)".formattedToReading
        favoriteRecipe.image = recipe.image
        favoriteRecipe.totalTime = recipe.totalTime
        favoriteRecipe.yield = recipe.yield
        favoriteRecipe.imageData = recipe.imageData
        favoriteRecipe.url = recipe.url
//        let favoriteRecipe = RecipeDetails(context: coreDataManager.persistentContainer.viewContext)
//        favoriteRecipe.name = recipe.name
//        favoriteRecipe.ingredientLines = recipe.ingredientLines
//        favoriteRecipe.imageData = recipe.imageData
//        favoriteRecipe.totalTime = recipe.totalTime
//        
//        favoriteRecipe.yield = recipe.yield
        do {
            try coreDataManager.persistentContainer.viewContext.save()
            print("SuccessFully save")
        } catch {
            displayAlert(message: "Can't save recipe")
        }
    }
}
