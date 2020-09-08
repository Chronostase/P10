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
    
    @IBOutlet var placeholderView: PlaceholderView!
    @IBOutlet weak var tableView: UITableView!
    var coreDataManager = CoreDataManager()
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        editTableView(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        showPlaceholderView()
    }
    
    private func setup() {
        setupCustomCell()
        setTableViewDelegate()
    }
    
    /** Add placholderView to indicate to user that something wrong append like no favorite to show */
    func showPlaceholderView() {
        guard let favoritesRecipe = coreDataManager.read() else {
            return
        }
        if favoritesRecipe.isEmpty {
            DispatchQueue.main.async {
                self.placeholderView.isHidden = false
            }
        } else {
            DispatchQueue.main.async {
                self.placeholderView.isHidden = true
            }
        }
    }
    
    /**Set the editing mode to On or Off, change edit button name*/
    private func editTableView(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            sender.title = Constants.UIElement.editButton
            tableView.setEditing(false, animated: true)
        }else {
            sender.title = Constants.UIElement.doneButton
            tableView.setEditing(true, animated: true)
        }
    }
    
    /**fetch customCell*/
    private func setupCustomCell() {
        let nib = UINib(nibName: Constants.Cell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.Cell.identifier)
    }
    
    /**Set tableViewDelegate and Datasource to self*/
    private func setTableViewDelegate() {
        tableView.dataSource = self 
        tableView.delegate = self
    }
    
    /**Push the recipeDetailViewController */
    func pushRecipeDetail(withRecipe recipe: RecipeDetails) {
        let storyBoard = UIStoryboard(name: Constants.Storyboard.recipeDetailName, bundle: nil)
        guard let recipeDetailController = storyBoard.instantiateInitialViewController() as? RecipeDetailViewController else {
            return
        }
        recipeDetailController.recipe = recipe
        push(recipeDetailController)
    }
}
