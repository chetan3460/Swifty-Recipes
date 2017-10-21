//
//  AddViewController.swift
//  Swifty Recipes
//
//  Created by Frank Ehlers on 15.10.17.
//  Copyright © 2017 Frank Ehlers. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var textfields: [UITextField]!
    @IBOutlet var pickers: [UIPickerView]!
    
    var imagePicker = UIImagePickerController()
    var ingredientArray = [String]()         // Datasource für TableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        tableView.dataSource = self
        
        textfields = textfields.sorted(by: {$0.tag < $1.tag})
        for textfield in textfields {
            textfield.delegate = self
        }
        
        pickers = pickers.sorted(by: {$0.tag < $1.tag})
        for picker in pickers {
            picker.delegate = self
            picker.dataSource = self
        }
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        instructionsTextView.inputAccessoryView = keyboardToolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addIngredient() {
        tableViewHeightConstraint.constant = CGFloat(Double(ingredientArray.count))*30
        let indexPath = IndexPath(row: ingredientArray.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
    
    func showPickerSelectionActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take photo", style: .default)
        { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                // Bild mit Kamera machen
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                Utility.showAlertView(with: "No camera available", and: "In order to use a camera your devvice needs one that can be accessed", in: self)
            }
        }
        let libraryAction = UIAlertAction(title: "Choose from photos", style: .default)
        { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)

        
    }

    @IBAction func addImageButtonHandler(_ sender: UIButton) {
        showPickerSelectionActionSheet()
    }
    @IBAction func addIngredientButtonHandler(_ sender: UIButton) {
        if let ingredient = textfields[2].text, !ingredient.isEmpty {
            ingredientArray.append(ingredient)
            addIngredient()
            textfields[2].text = ""
        }
    }
    @IBAction func saveButtonHandler(_ sender: UIBarButtonItem) {
        guard let image = imageView.image else {
            Utility.showAlertView(with: "No image", and: "Please add an image to your recipe", in: self)
            return
        }
        guard let title = textfields[0].text, !title.isEmpty else {
            Utility.showAlertView(with: "No title", and: "Please add a name for your recipe", in: self)
            return
        }
        guard let shortDescription = textfields[1].text, !shortDescription.isEmpty else {
            Utility.showAlertView(with: "No description", and: "Please add a short description to your recipe", in: self)
            return
        }
        guard let instructions = instructionsTextView.text, !instructions.isEmpty else {
            Utility.showAlertView(with: "No instrutctions", and: "Please add instructions for your recipe", in: self)
            return
        }
        guard ingredientArray.count > 0 else {
            Utility.showAlertView(with: "No ingredients", and: "Please add at lease one ingredient for your recipe", in: self)
            return
        }
        guard let difficulty = getSelectedItem(for: pickers[0]) else {
            
            return
        }
        guard let category = getSelectedItem(for: pickers[1]) else {
            return
        }
        guard let servings = getSelectedItem(for: pickers[2]) else {
            return
        }
        
        SVProgressHUD.show(withStatus: "Uploading image...")
        FirebaseHelper.upload(image: image, to: FirebaseStrings.imageDirectory)
        { (url) in
            SVProgressHUD.dismiss()
            if let url = url {
                let recipe = Recipe(title: title, shortDescription: shortDescription, category: category, difficulty: difficulty, servings: servings, instructions: instructions, ingredients: self.ingredientArray, imageURL: url.absoluteString)
                self.createRecipePost(for: recipe)
            } else {
                Utility.showAlertView(with: "Image upload failed", and: "There was a problem with the ipload. Please check yout connection", in: self)
            }
            
        }

//        print("We have all the data needed for a recipe with: \(title), \(shortDescription), \(instructions), \(ingredientArray), \(image), \(difficulty), \(category), \(servings)")
//        resetAddViewController()
    }
    
    func createRecipePost(for recipe: Recipe) {
        guard let userID = UserDefaults.standard.string(forKey: "userID") else {
            Utility.showAlertView(with: "No valid user", and: "You have to be logged in to post", in: self)
            return
        }
        SVProgressHUD.show(withStatus: "Savein recipe...")
        FirebaseHelper.saveDatabaseEntry(to: FirebaseStrings.postDirectory, with: recipe, by: userID) 
        { (success) in
            SVProgressHUD.dismiss()
            if success {
                self.resetAddViewController()
            } else {
                Utility.showAlertView(with: "Saving failed", and: "We could not save your recipe. Please try again", in: self)
            }
        }
    }
    
    func resetAddViewController() {
        for textfield in textfields {
            textfield.text = ""
        }
        
        for picker in pickers {
            picker.selectRow(0, inComponent: 0, animated: true)
        }
        instructionsTextView.text = ""
        imageView.image = nil
        ingredientArray.removeAll()
        tableView.reloadData()
        tableViewHeightConstraint.constant = 0.0
    }
    
}

extension AddViewController: IngredientCellDelegate {
    func deleteButtonTapped(for cell: IngredientTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        ingredientArray.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        tableViewHeightConstraint.constant = CGFloat(Double(ingredientArray.count))*30

    }
}

extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 2 {
            if let ingredient = textField.text, !ingredient.isEmpty {
                ingredientArray.append(ingredient)
                addIngredient()
                textField.text = ""
            }
        }
        textField.resignFirstResponder()
        return true
    }
}

extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func getSelectedItem(for picker: UIPickerView) -> String? {
        let index = picker.selectedRow(inComponent: 0)
        let string = pickerView(picker, titleForRow: index, forComponent: 0)
        return string
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return Recipe.difficulties.count
        case 1:
            return Recipe.categories.count
        case 2:
            return 10
        default:
            return 0
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return Recipe.difficulties[row]
        case 1:
            return Recipe.categories[row]
        case 2:
            return "\(row + 1)"
        default:
            return nil
        }
    }
}

extension AddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientTableViewCell {
            cell.delegate = self
            cell.ingredientLabel.text = ingredientArray[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


