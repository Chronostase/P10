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
}

class ReusableRecipeListViewController: UIViewController {
    
    var dataSourceType: DataSource = .coreData
    var recipelist: RecipeList?
    var coreDataManager = CoreDataManager()
    
    @IBOutlet var placeHolder: [PlaceholderView]!
    @IBOutlet var tableView: [UITableView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        print("HEEERRREEEE")
    }
    override func viewWillAppear(_ animated: Bool) {
        if dataSourceType == .coreData {
            for table in tableView {
                if table.tag == 1 {
                    table.reloadData()
                }
            }
        }
        showPlaceholderView()
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if selectCorrespondingTableView().isEditing {
            sender.title = Constants.UIElement.editButton
            selectCorrespondingTableView().setEditing(false, animated: true)
        }else {
            sender.title = Constants.UIElement.doneButton
            selectCorrespondingTableView().setEditing(true, animated: true)
        }
    }
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        if dataSourceType == .api {
            changeDataSourceType()
        }
        navigationController?.popViewController(animated: true)
    }
    
    func changeDataSourceType() {
        dataSourceType = .coreData
    }
    
    private func setupTableView() {
        setTableViewDataSourceAndDelegate()
        setupCustomCell()
    }
    
    private func selectCorrespondingTableView() -> UITableView {
        if dataSourceType == .api {
            for table in tableView {
                if table.tag == 0 {
                    return table
                }
            }
        } else {
            for table in tableView {
                if table.tag == 1 {
                    return table
                }
            }
        }
        return UITableView()
    }
    
    private func selectCorrespondingPlaceHolder() -> PlaceholderView {
        if dataSourceType == .api {
            for placeHolder in placeHolder {
                if placeHolder.tag == 0 {
                    return placeHolder
                }
            }
        } else {
            for placeholder in placeHolder {
                if placeholder.tag == 1 {
                    return placeholder
                }
            }
        }
        return PlaceholderView()
    }
        
        /**Fetch custom cell*/
        private func setupCustomCell() {
            let nib = UINib(nibName: Constants.Cell.nibName, bundle: nil)
            selectCorrespondingTableView().register(nib, forCellReuseIdentifier: Constants.Cell.identifier)
        }
        
        
        private func setTableViewDataSourceAndDelegate() {
            selectCorrespondingTableView().dataSource = self
            selectCorrespondingTableView().delegate = self
        }
        
        /** Add placholderView to indicate to user that something wrong append like no favorite to show */
        func showPlaceholderView() {
            
            if dataSourceType == .api {
                guard let isRecipeListEmpty = recipelist?.hits.isEmpty else {
                    return
                }
                if isRecipeListEmpty {
                    DispatchQueue.main.async {
                        self.selectCorrespondingPlaceHolder().isHidden = false
                    }
                } else {
                    self.selectCorrespondingPlaceHolder().isHidden = true
                }
                
            } else if dataSourceType == .coreData {
                guard let isFavoritesEmpty = coreDataManager.read()?.isEmpty else {
                    return
                }
                
                if isFavoritesEmpty {
                    DispatchQueue.main.async {
                        self.selectCorrespondingPlaceHolder().isHidden = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.selectCorrespondingPlaceHolder().isHidden = true
                    }
                }
            }
        }
        
        
        /**Push RecipeDetailViewController*/
        func pushRecipeDetail(withRecipe recipe: RecipeDetails, indexPath: IndexPath? = nil) {
            if dataSourceType == .coreData {
                let storyBoard = UIStoryboard(name: Constants.Storyboard.recipeDetailName, bundle: nil)
                guard let recipeDetailController = storyBoard.instantiateInitialViewController() as? RecipeDetailViewController else {
                    return
                }
                recipeDetailController.recipe = recipe
                push(recipeDetailController)
                
            } else if dataSourceType == .api {
                
                let storyBoard = UIStoryboard(name: Constants.Storyboard.recipeDetailName, bundle: nil)
                guard let recipeDetailController = storyBoard.instantiateInitialViewController() as? RecipeDetailViewController else {
                    return
                }
                recipeDetailController.recipe = recipe
                
                guard let indexPath = indexPath, let cell = selectCorrespondingTableView().cellForRow(at: indexPath) as? CustomTableViewCell, let image = cell.recipeImage.image else {
                    return
                }
                
                recipeDetailController.recipe?.imageData = image.pngData()
                push(recipeDetailController)
            }
        }
        
}
