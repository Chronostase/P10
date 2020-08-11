//
//  RoundedButton.swift
//  Reciplease
//
//  Created by Thomas on 11/08/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNeedsLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //Set aspect of UIElement
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutIfNeeded()
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
    }
}
