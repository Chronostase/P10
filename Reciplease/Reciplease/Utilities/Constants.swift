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
    
    enum ControllerName {
        static let reciplease = "Reciplease"
    }
    
    enum Service {
        static let baseUrl = "https://api.edamam.com/search?q="
        static let idParameter = "&app_id="
        static let keyParameter = "&app_key="
        
    }
    
    enum UIElement {
        static let addButton = "Add"
        static let editButton = "Edit"
        static let doneButton = "Done"
        static let placeholderImage = "placeholder"
        static let watchImage = "watch"
        static let likeImage = "like"
        static let alertButton = "OK"
    }
    
    enum CoreDataError {
        static let saveError = "Can't save recipe"
    }
    
    enum AppIdAndKey {
        static let recipeSearchId = "recipeSearchAppId"
        static let recipeSearchKey = "recipeSearchAppKey"
    }
    
}

