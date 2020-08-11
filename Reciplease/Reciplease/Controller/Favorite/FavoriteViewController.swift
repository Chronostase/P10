//
//  FavoriteViewController.swift
//  Reciplease
//
//  Created by Thomas on 15/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import UIKit

class FavoriteViewController: UIViewController {
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    var coreDataManager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupCustomCell()
        setTableViewDelegate()
        setNavigationBarTitle(title: "Favorites", navItem: navItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupCustomCell() {
        let nib = UINib(nibName: Constants.Cell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.Cell.identifier)
    }
    
    private func setTableViewDelegate() {
        tableView.dataSource = self 
        tableView.delegate = self
    }
    
    func pushRecipeDetail(withRecipe recipe: RecipeDetails) {
        let storyBoard = UIStoryboard(name: Constants.Storyboard.recipeDetailName, bundle: nil)
        guard let recipeDetailController = storyBoard.instantiateInitialViewController() as? RecipeDetailViewController else {
            return
        }
        recipeDetailController.recipe = recipe
        push(recipeDetailController)
    }
}
