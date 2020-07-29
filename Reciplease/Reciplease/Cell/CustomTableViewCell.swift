//
//  CustomTableViewCell.swift
//  GreaTrip
//
//  Created by Thomas on 08/05/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import UIKit

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
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Configure cell with all properties
    func configureCell(recipeImage: Data, recipeName: String, recipeDetails: String, notationLabel: Double, durationLabel: Double) {
        self.recipeImage.image = UIImage(data: recipeImage)
        self.recipeName.text = recipeName
        self.recipeDetails.text = recipeDetails
        self.notationLabel.text = "\(notationLabel)"
        self.durationLabel.text = "\(durationLabel)"
        
    }
}

