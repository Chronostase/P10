//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Thomas on 15/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//
import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var ingredientsListTextView: UITextView!
    var recipeList: RecipeList?
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        getRecipes()
    }
    @IBAction func ClearButton(_ sender: UIButton) {
        ingredientsListTextView.text = ""
    }
    
    private func getRecipes() {
        let text = ingredientsListTextView.text.formattedToRequest
        RecipeService().getData(userEntry: text) { [weak self] result in
            switch result {
            case .success(let recipe):
                guard let recipe = recipe else {
                    return
                }
                self?.recipeList = recipe
                self?.getImages()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getImages() {
        guard let imageUrls = recipeList?.hits.map({$0.recipe.image}) else {
            return
        }
        
        var imageUrlsCount = imageUrls.count - 1
        
        imageUrls.enumerated().forEach { url in
            RecipeService().getImage(url: url.element) { [weak self] result in
                switch result {
                case .success(let data):
                    guard let data = data else {
                        return
                    }
                    
                    self?.recipeList?.hits[url.offset].recipe.imageData = data
                    
                    if url.offset == imageUrlsCount {
                        // All calls done
                        self?.pushRecipeListTableView()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    //Vérifier quand le dernier fail
                    imageUrlsCount -= 1
                    
                    guard let placeholderImage = UIImage(named: "placeholder")?.pngData() else {
                        return
                    }
                    
                    self?.recipeList?.hits[url.offset].recipe.imageData = placeholderImage
                }
            }
        }
    }
    
    private func setup() {
        setTextFielAndTextViewdDelegate()
        setupAddButton()
    }
    
    /** Set user entry to textView */
    private func setTextFieldValueToTextView() {
        guard let text = ingredientsTextField.text else {
            return
        }
        let formatedText = "\n \n - \(text)"
        ingredientsListTextView.text += formatedText
    }
    
    /** add an add button to toolbar */
    private func setupAddButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(tapDoneButton))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        ingredientsTextField.inputAccessoryView = toolBar
    }
    
    @objc func tapDoneButton() {
        setTextFieldValueToTextView()
        ingredientsTextField.text = nil 
    }
    
    /** Set textField and TextViewDelegate to SearchViewController */
    private func setTextFielAndTextViewdDelegate() {
        ingredientsTextField.delegate = self
        ingredientsListTextView.delegate = self
    }
    
    /** push RecipeListViewController */
    private func pushRecipeListTableView() {
        let storyBoard = UIStoryboard(name: Constants.Storyboard.recipeListName, bundle: nil)
        guard let recipeListViewController = storyBoard.instantiateInitialViewController() as? RecipeListViewController else {
            return
        }
        recipeListViewController.recipeList = recipeList
        push(recipeListViewController)
    }
    
}
