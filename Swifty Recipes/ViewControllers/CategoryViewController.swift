//
//  CategoryViewController.swift
//  Swifty Recipes
//
//  Created by Frank Ehlers on 14.10.17.
//  Copyright © 2017 Frank Ehlers. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var filterValue = "Meats"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryStreamSegue" {
            if let contentViewController = segue.destination as? ContentViewController {
                contentViewController.title = filterValue
                contentViewController.filter = "category"
                contentViewController.filterValue = filterValue
            }
        }
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Recipe.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as?
            CategoryTableViewCell {
                cell.categoryImageView.image = UIImage(named: Recipe.categories[indexPath.row])
                cell.categoryLabel.text = Recipe.categories[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as?
            CategoryTableViewCell, let title = cell.categoryLabel.text {
            filterValue = title
        }
        performSegue(withIdentifier: "CategoryStreamSegue", sender: nil)
    }
}
