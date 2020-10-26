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
    
    @IBOutlet var placholderView: PlaceholderView!
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
            placholderView.isHidden = false
        } else {
            placholderView.isHidden = true
            getRecipes()
        }
    }
    @IBAction func clearButton(_ sender: UIButton) {
        ingredientsListTextView.text = ""
        placholderView.isHidden = false
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
                // Take care here
                guard let recipeList = recipeList else {
                    return
                }
                //
                guard !recipeList.hits.isEmpty else {
                    self?.displayAlert(message: Constants.Error.userEntryError)
                    self?.ingredientsListTextView.text = nil
                    return
                }
                self?.recipeList = recipeList
                self?.pushRecipeListTableView()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /** Set textField and textView Delegate and add button to keyboard toolbar*/
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
        let doneButton = UIBarButtonItem(title: Constants.UIElement.addButton, style: .done, target: self, action: #selector(tapAddButton))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        ingredientsTextField.inputAccessoryView = toolBar
    }
    
    @objc func tapAddButton() {
        if textFieldIsEmpty() {
            if ingredientsListTextView.text == nil {
                placholderView.isHidden = false
            } else {
                placholderView.isHidden = false
                ingredientsListTextView.isHidden = true
            }
        } else {
            setTextFieldValueToTextView()
            ingredientsTextField.text = nil
            ingredientsListTextView.isHidden = false
            placholderView.isHidden = true
        }
    }
    
    private func textFieldIsEmpty() -> Bool {
        guard let isEmpty = ingredientsTextField.text?.isEmpty else {
            return true
        }
        return isEmpty
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
        recipeListViewController.navigationController?.navigationBar.topItem?.title = Constants.ControllerName.reciplease
        push(recipeListViewController)
    }
    
}
