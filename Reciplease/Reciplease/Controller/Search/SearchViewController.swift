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
    
    
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var ingredientsListTextView: UITextView!
    var recipeList: RecipeList?
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        ingredientsTextField.resignFirstResponder()
        getRecipes()
    }
    @IBAction func ClearButton(_ sender: UIButton) {
        ingredientsListTextView.text = ""
    }
    
    private func constrainTextField() {
        guard let textFieldIsEmpty = ingredientsTextField.text?.isEmpty else {
            return
        }
        if textFieldIsEmpty == true {
            //Display view to say that there is no entry
        }
    }
    
    private func getRecipes() {
        let text = ingredientsListTextView.text.formattedToRequest
        self.showIndicator()
        RecipeService().getData(userEntry: text) { [weak self] result in
            self?.hideIndicator()
            switch result {
            case .success(let recipeList):
                guard let recipeList = recipeList else {
                    print("there is no recipeList")
                    return
                }
                self?.recipeList = recipeList
                self?.getImages()
                
                print(recipeList.hits.count)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getImages() {
        guard let imageUrls = recipeList?.hits.compactMap({$0.recipe.image}) else {
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
                    print("Image data received, \(String(describing: self?.recipeList?.hits[url.offset].recipe.imageData))")
                    
                    if (self?.recipeList?.hits.filter({ $0.recipe.imageData == nil }).isEmpty) == true {
                        // All calls done
                        print("\n")
                        self?.recipeList?.hits.forEach {
                            print($0.recipe.imageData as Any)
                        }
                        self?.pushRecipeListTableView()
                        return
                    }
                case .failure(let error):
                    print("Image data fetch failed")
                    print(error.localizedDescription)
                    imageUrlsCount -= 1
                    
                    self?.setImagePlaceHolder(at: url.offset)
                    //Filtre image data == nil si ça fonctionne rentre dans la condi, gérer cas particulier
                    if (self?.recipeList?.hits.filter({ $0.recipe.imageData == nil }).isEmpty) == true {
                        print("\n")
                        self?.recipeList?.hits.forEach {
                            print($0.recipe.imageData as Any)
                        }
                        self?.pushRecipeListTableView()
                        return
                    } else {
                        print("ENTER IN ERROR CASE ")
                    }
                }
            }
        }
    }
    
    /** Set textField and textView Delegate and add button to keyboard toolbar*/
    private func setup() {
        setTextFielAndTextViewdDelegate()
        setNavigationBarTitle(title: "Reciplease", navItem: navItem)
        setupAddButton()
    }
    
    /** Set image PlaceHolder*/
    private func setImagePlaceHolder(at index: Int) {
        guard let placeholderImage = UIImage(named: "placeholder")?.pngData() else {
            return
        }
        
        self.recipeList?.hits[index].recipe.imageData = placeholderImage
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
        let doneButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(tapAddButton))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        ingredientsTextField.inputAccessoryView = toolBar
    }
    
    @objc func tapAddButton() {
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
        recipeListViewController.navigationController?.navigationBar.topItem?.title = "Reciplease"
        push(recipeListViewController)
    }
    
}
