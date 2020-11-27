//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Thomas on 15/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//
import UIKit

class SearchViewController: UIViewController, UITextViewDelegate {
    
    //MARK: - Properties
    
    @IBOutlet var placeHolderView: PlaceholderView!
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
        if ingredientsTextViewIsEmpty() {
            placeHolderView.isHidden = false
        } else {
            placeHolderView.isHidden = true
            getRecipes()
        }
    }
    
    /** Remove all ingredients from textView */
    @IBAction func clearButton(_ sender: UIButton) {
        ingredientsListTextView.text = ""
        placeHolderView.isHidden = false
    }
    
    /** Set textField and textView Delegate and add button to keyboard toolbar*/
    private func setup() {
        setTextFielAndTextViewdDelegate()
        setupAddButton()
    }
    
      /** Set textField and TextViewDelegate to SearchViewController */
      private func setTextFielAndTextViewdDelegate() {
          ingredientsTextField.delegate = self
          ingredientsListTextView.delegate = self
      }
    
    /** add an add button to toolbar */
    private func setupAddButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: Constants.UIElement.addButton, style: .done, target: self, action: #selector(tapAddButton))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        ingredientsTextField.inputAccessoryView = toolBar
    }
    
    /** Allow to show placeHolder if TextView is empty when user push add Button, and add ingredient in textView if user type something in textField */
       @objc func tapAddButton() {
           if textFieldIsEmpty() {
               if ingredientsListTextView.text == nil {
                   placeHolderView.isHidden = false
               } else {
                   placeHolderView.isHidden = false
                   ingredientsListTextView.isHidden = true
               }
           } else {
               setTextFieldValueToTextView()
               ingredientsTextField.text = nil
               ingredientsListTextView.isHidden = false
               placeHolderView.isHidden = true
           }
       }
    
    /** Check if textField is empty*/
    private func textFieldIsEmpty() -> Bool {
        guard let isEmpty = ingredientsTextField.text?.isEmpty else {
            return true
        }
        return isEmpty
    }
    
    /** Set user entry to textView */
    private func setTextFieldValueToTextView() {
        guard let text = ingredientsTextField.text else {
            return
        }
        let formatedText = "\n \n - \(text)"
        ingredientsListTextView.text += formatedText
    }
    
    /**Check if textView is empty and return Bool*/
    private func ingredientsTextViewIsEmpty() -> Bool {
        return self.ingredientsListTextView.text.isEmpty
    }
    
    /**Launch recipeCall with user ingredients*/
    private func getRecipes() {
        let text = ingredientsListTextView.text.formattedToRequest
        self.showIndicator()
        RecipeService().getData(userEntry: text) { [weak self] result in
            self?.hideIndicator()
            switch result {
            case .success(let recipeList) :
                
                guard let recipeList = recipeList else {
                    return
                }
                
                guard !recipeList.hits.isEmpty else {
                    self?.displayAlert(message: Constants.Error.userEntryError)
                    self?.ingredientsListTextView.text = nil
                    self?.placeHolderView.isHidden = false
                    return
                }
                self?.recipeList = recipeList
                self?.pushReusableRecipeList()
                
            case .failure(let error):
                self?.displayAlert(message: "Something wrong append please check your connection")
                print(error.localizedDescription)
            }
        }
    }

    /** push RecipeListViewController */
    private func pushReusableRecipeList() {
        let storyBoard = UIStoryboard(name: Constants.Storyboard.favorite, bundle: nil)
        guard let reusableRecipeListViewController = storyBoard.instantiateInitialViewController() as? ReusableRecipeListViewController else {
            return
        }
        reusableRecipeListViewController.recipelist = recipeList
        reusableRecipeListViewController.dataSourceType = .api
        
        push(reusableRecipeListViewController)
    }
    
}
