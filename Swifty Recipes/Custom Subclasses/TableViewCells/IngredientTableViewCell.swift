//
//  IngredientTableViewCell.swift
//  Swifty Recipes
//
//  Created by Frank Ehlers on 15.10.17.
//  Copyright © 2017 Frank Ehlers. All rights reserved.
//

import UIKit

protocol IngredientCellDelegate {
    func deleteButtonTapped(for cell: IngredientTableViewCell)
}

class IngredientTableViewCell: UITableViewCell {

    var delegate: IngredientCellDelegate?
    
    @IBOutlet weak var ingredientLabel: UILabel!
    
    @IBAction func deleteButtonHandler(_ sender: UIButton) {
        delegate?.deleteButtonTapped(for: self)
    }
    
}
