//
//  ReusableReciplistViewController.swift
//  Reciplease
//
//  Created by Thomas on 02/11/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import UIKit

enum DataSource {
    case api
    case coreData
    
    var title: String {
        switch  self {
        case .api:
            return "Research"
        case .coreData:
            return "Favorites"
        }
    }
}

class ReusableRecipeListViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: - Properties
    
    var dataSourceType: DataSource = .coreData
    var recipelist: RecipeList?
    var coreDataManager = CoreDataManager()
    
    @IBOutlet var navigationStuff: UINavigationItem!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var placeHolder: PlaceholderView!
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.navigationItem.title = ""
        self.navigationController?.title = ""
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if dataSourceType == .coreData {
            tableView.reloadData()
        }
        showPlaceholderView()
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        setEditingMode(sender)
    }
    
    /** defind if tableView need to be in edit mode */
    private func setEditingMode(_ sender: UIBarButtonItem) {
        if dataSourceType != .api {
            if tableView.isEditing {
                sender.title = Constants.UIElement.editButton
                tableView.setEditing(false, animated: true)
            }else {
                sender.title = Constants.UIElement.doneButton
                tableView.setEditing(true, animated: true)
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        if dataSourceType == .api {
            dataSourceType = .coreData
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func setup() {
        setupTableView()
        setupButton()
        setNavigationItemTitle()
    }
    
    private func setNavigationItemTitle() {
        self.navigationStuff.title = dataSourceType.title
    }
    
    private func setupButton() {
        switch dataSourceType {
        case .api :
            
            editButton.isEnabled = false
            editButton.tintColor = .clear
            backButton.isEnabled = true
            backButton.tintColor = .systemBlue
        case .coreData :
            
            editButton.isEnabled = true
            editButton.tintColor = .systemBlue
            backButton.isEnabled = false
            backButton.tintColor = .clear
        }
    }
    
    private func setupTableView() {
        setTableViewDataSourceAndDelegate()
        setupCustomCell()
    }
    
    /**Fetch custom cell*/
    private func setupCustomCell() {
        let nib = UINib(nibName: Constants.Cell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.Cell.identifier)
    }
    
    private func setTableViewDataSourceAndDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    /** Add placholderView to indicate to user that something wrong append like no favorite to show */
       func showPlaceholderView() {
           switch dataSourceType {
           case .api :
               
               if dataSourceType == .api {
                   guard let isRecipeListEmpty = recipelist?.hits.isEmpty else {
                       return
                   }
                   if isRecipeListEmpty {
                       DispatchQueue.main.async {
                           self.placeHolder.isHidden = false
                       }
                   } else {
                       self.placeHolder.isHidden = true
                   }
               }
           case .coreData :
               
               guard let isFavoritesEmpty = coreDataManager.read()?.isEmpty else {
                   return
               }
               
               if isFavoritesEmpty {
                   DispatchQueue.main.async {
                       self.placeHolder.isHidden = false
                   }
               } else {
                   DispatchQueue.main.async {
                       self.placeHolder.isHidden = true
                   }
               }
           }
       }
    
    /**Push RecipeDetailViewController*/
    func pushRecipeDetail(withRecipe recipe: RecipeDetails, indexPath: IndexPath? = nil) {
        
        switch dataSourceType {
        case .api:
            
            let storyBoard = UIStoryboard(name: Constants.Storyboard.recipeDetailName, bundle: nil)
            guard let recipeDetailController = storyBoard.instantiateInitialViewController() as? RecipeDetailViewController else {
                return
            }
            recipeDetailController.recipe = recipe
            
            guard let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell, let image = cell.recipeImage.image else {
                return
            }
            
            recipeDetailController.recipe?.imageData = image.pngData()
            push(recipeDetailController)
        case .coreData:
            
            let storyBoard = UIStoryboard(name: Constants.Storyboard.recipeDetailName, bundle: nil)
            guard let recipeDetailController = storyBoard.instantiateInitialViewController() as? RecipeDetailViewController else {
                return
            }
            recipeDetailController.recipe = recipe
            push(recipeDetailController)
            
        }
    }
    
}
