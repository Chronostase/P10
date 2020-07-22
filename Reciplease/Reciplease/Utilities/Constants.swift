//
//  Constants.swift
//  GreaTrip
//
//  Created by Thomas on 09/06/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation

enum Constants {
    
    enum Error {
        static let networkError = "Something wrong append, please check your connection and retry"
        static let errorTitle = "Error !"
        static let actionTitle = "OK"
        static let dataError = "Empty or corrupted Data"
        static let simpleError = "An error append"
        static let responseError = "Response isn't HTTPURLResponse type"
        static let statusCodeError = "Status code isn't in range of 200 to 299"
        static let decodingError = "Can't Decode Object"
        static let requestError = "Something wrong append with request please retry"
        static let userEntryError = "Your data are not correct, please retry"
    }
    
    enum Cell {
        static let identifier = "Cell"
        static let nibName = "CustomCell"
    }
    
    enum Storyboard {
        static let recipeListName = "RecipeList"
        static let recipeDetailName = "RecipeDetail"
    }
    
    enum Service {
        static let baseUrl = "https://api.edamam.com/search?q="
        static let idParameter = "&app_id="
        static let keyParameter = "&app_key="
        
    }
    
}

