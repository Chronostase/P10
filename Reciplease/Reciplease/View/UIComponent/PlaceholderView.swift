//
//  PlaceholderView.swift
//  Reciplease
//
//  Created by Thomas on 26/08/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import UIKit

@IBDesignable
class PlaceholderView: UIView {

    let label: UILabel = UILabel()
    var stackView: UIStackView = UIStackView()
    var imageView: UIImageView = UIImageView()
    
    @IBInspectable var title: String? {
        didSet {
            label.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    private func commonInit() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        imageView.image = UIImage(named: "chef")
        imageView.tintColor = .white
        label.textColor = .white
        label.numberOfLines = 0
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(imageView)
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label.textAlignment = .center
    }

}
