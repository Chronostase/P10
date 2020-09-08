//
//  CustomTableViewCell.swift
//  GreaTrip
//
//  Created by Thomas on 08/05/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import UIKit
import Kingfisher

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeDetails: UILabel!
    @IBOutlet weak var notationLabel: UILabel!
    @IBOutlet weak var notationImage: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Configure cell with all properties
    func configureCell(recipe: RecipeDetails) {
        let url = URL(string: recipe.image)
        self.recipeImage.kf.setImage(with: url, placeholder: UIImage(named: Constants.UIElement.placeholderImage), options: nil, progressBlock: nil)
        self.recipeName.text = recipe.label
        self.recipeDetails.text = recipe.ingredientLines.first
        self.notationLabel.text = "\(Int(recipe.yield).formatUsingAbbrevation())"
        self.durationLabel.text = "\(recipe.totalTime.convertMinutesInHours)"
        self.notationImage.image = UIImage(named: Constants.UIElement.watchImage)
        self.durationImage.image = UIImage(named: Constants.UIElement.likeImage)
    }
}

