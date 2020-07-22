//
//  RecipeDetails.swift
//  Reciplease
//
//  Created by Thomas on 22/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailViewController: UIViewController {
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var getDirectionButton: UIButton!
    
    var recipe: RecipeDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI () {
        
        guard let imageData = recipe?.imageData else {
            return
        }
        let image = UIImage(data: imageData)
        recipeImage.image = image
        ingredientsTextView.text = "\(recipe?.ingredientLines ?? [""])".formattedToReading
    }
}
