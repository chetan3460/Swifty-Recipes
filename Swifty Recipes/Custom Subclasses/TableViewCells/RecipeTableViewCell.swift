//
//  RecipeTableViewCell.swift
//  Swifty Recipes
//
//  Created by Frank Ehlers on 14.10.17.
//  Copyright © 2017 Frank Ehlers. All rights reserved.
//

import UIKit

protocol RecipeCellDelegate {
    func detailButtonTapped(sender: RecipeTableViewCell)
}

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeShortDescriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var delegate: RecipeCellDelegate?
    var recipe: Recipe?
    
    func configure(for recipe: Recipe, delegate: RecipeCellDelegate) {
        recipeTitleLabel.text = recipe.title
        recipeShortDescriptionLabel.text = recipe.shortDescription
//        if let image = UIImage(named: recipe.imageURL) {  // Image laden vor Datenbankanbindung
//            recipeImageView.image = image
//        }
        
        if let image = Utility.imageCache.object(forKey: recipe.imageURL as NSString) {
            recipeImageView.image = image
        } else {
            self.activityIndicator.startAnimating()
            FirebaseHelper.downloadImage(for: recipe.imageURL, completion: { (image) in
                self.activityIndicator.stopAnimating()
                Utility.imageCache.setObject(image, forKey: recipe.imageURL as NSString)
                self.recipeImageView.image = image
            })
        }
        
        self.recipe = recipe
        self.delegate = delegate
    }
    
    @IBAction func buttonHandler(_ sender: Any) {
        delegate?.detailButtonTapped(sender: self)
    }
    
}
