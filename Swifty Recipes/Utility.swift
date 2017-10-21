//
//  Utility.swift
//  Swifty Recipes
//
//  Created by Frank Ehlers on 15.10.17.
//  Copyright © 2017 Frank Ehlers. All rights reserved.
//

import UIKit

enum Utility {
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    static func showAlertView(with title: String, and message: String, in viewcontroller: UIViewController) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertViewController.addAction(cancelAction)
        viewcontroller.present(alertViewController, animated: true, completion: nil)
    }
}
