//
//  DetailViewController.swift
//  Swifty Recipes
//
//  Created by Frank Ehlers on 14.10.17.
//  Copyright © 2017 Frank Ehlers. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeShortDescription: UILabel!
    @IBOutlet weak var recipeInstructionsLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var recipe: Recipe?
    var ingredientArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        if let recipe = recipe {
            
        }
    }
    
    func display(_ recipe: Recipe) {
        recipeTitleLabel.text = recipe.title
        recipeShortDescription.text = recipe.shortDescription
        recipeInstructionsLabel.text = recipe.instructions
        difficultyLabel.text = recipe.difficulty
        categoryLabel.text = recipe.category
        servingsLabel.text = recipe.servings
        ingredientArray = recipe.ingredients
        
        if let image = Utility.imageCache.object(forKey: recipe.imageURL as NSString) {
            recipeImageView.image = image
        } else {
            FirebaseHelper.downloadImage(for: recipe.imageURL, completion: { (image) in
                Utility.imageCache.setObject(image, forKey: recipe.imageURL as NSString)
                self.recipeImageView.image = image
            })
        }
        
        tableViewHeightConstraint.constant = CGFloat(Double(ingredientArray.count) * 30.0)
        tableView.reloadData()
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = ingredientArray[indexPath.row]
        return cell
    }
}
