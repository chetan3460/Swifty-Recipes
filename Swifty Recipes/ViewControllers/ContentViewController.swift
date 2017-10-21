//
//  ViewController.swift
//  Swifty Recipes
//
//  Created by Frank Ehlers on 14.10.17.
//  Copyright © 2017 Frank Ehlers. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseDatabase

class ContentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var filter: String?
    var filterValue: String?
    var recipes = [Recipe]()
    
    var recipeForSegue: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "Loading recipes...")
        view.backgroundColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        tableView.dataSource = self
        
        var databaseQuery: DatabaseQuery!
        
        if let filter = filter {
            if let filterValue = filterValue {
                databaseQuery = FirebaseHelper.postReference.queryOrdered(byChild: filter).queryEqual(toValue: filterValue)
            } else {
                databaseQuery = FirebaseHelper.postReference.queryOrdered(byChild: filter).queryLimited(toLast: 3)
            }
        } else {
            databaseQuery = FirebaseHelper.postReference
        }
        
        
        databaseQuery.observe(.value) { (snapshot) in
            self.recipes.removeAll()
            
            if let entries = snapshot.children.allObjects as? [DataSnapshot] {
                for entry in entries {
                    if let recipeData = entry.value as?
                        Dictionary<String,AnyObject> {
                        if let recipe = Recipe.recipe(for: recipeData) {
                            self.recipes.append(recipe)
                        }
                    }
                }
            }
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let detailViewController = segue.destination as?
                DetailViewController, let recipe = recipeForSegue {
                detailViewController.title = recipe.title
                detailViewController.recipe = recipe
            }
        }
    }

}

extension ContentViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
            as? RecipeTableViewCell {
            cell.configure(for: recipes[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
}

extension ContentViewController: RecipeCellDelegate {
    func detailButtonTapped(sender: RecipeTableViewCell) {
        if let recipe = sender.recipe {
            recipeForSegue = recipe
            performSegue(withIdentifier: "DetailSegue", sender: nil)
        }
    }
}

