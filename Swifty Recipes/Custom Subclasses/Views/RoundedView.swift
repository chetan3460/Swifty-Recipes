//
//  RoundedView.swift
//  Swifty Recipes
//
//  Created by Frank Ehlers on 14.10.17.
//  Copyright © 2017 Frank Ehlers. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
    
    @IBInspectable
    var corderRounding: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = corderRounding
        }
    }
    
    override func awakeFromNib() {
        layer.masksToBounds = true
    }
    
}
