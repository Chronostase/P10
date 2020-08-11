//
//  BorderedUiView.swift
//  Reciplease
//
//  Created by Thomas on 11/08/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import UIKit

class BorderedUIView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNeedsLayout()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
}
