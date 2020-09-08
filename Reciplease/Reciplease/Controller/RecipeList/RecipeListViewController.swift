//
//  SearchResultViewController.swift
//  Reciplease
//
//  Created by Thomas on 15/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import UIKit

class RecipeListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var placeholderView: PlaceholderView!
    
    var recipeList: RecipeList? 

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        showPlaceholderView()
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
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
    private func showPlaceholderView() {
        guard let favoritesRecipe = recipeList else {
            return
        }
        if favoritesRecipe.hits.isEmpty {
            DispatchQueue.main.async {
                self.placeholderView.isHidden = false
            }
        } else {
            DispatchQueue.main.async {
                self.placeholderView.isHidden = true
            }
        }
    }
    
    /**Push RecipeDetailViewController*/
    func pushRecipeDetail(withRecipe recipe: RecipeDetails, indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: Constants.Storyboard.recipeDetailName, bundle: nil)
        guard let recipeDetailController = storyBoard.instantiateInitialViewController() as? RecipeDetailViewController else {
            return
        }
        recipeDetailController.recipe = recipe
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell, let image = cell.recipeImage.image else {
            return
        }
        
        recipeDetailController.recipe?.imageData = image.pngData()
        push(recipeDetailController)
    }

}
