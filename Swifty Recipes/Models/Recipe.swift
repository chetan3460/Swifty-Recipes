//
//  Recipe.swift
//  Swifty Recipes
//
//  Created by Frank Ehlers on 14.10.17.
//  Copyright © 2017 Frank Ehlers. All rights reserved.
//

import Foundation

struct Recipe {
    var title: String
    var shortDescription: String
    var category: String
    var difficulty: String
    var servings: String
    var instructions: String
    var ingredients: [String]
    var imageURL: String
    
    static func recipe(for data: Dictionary<String,AnyObject>) -> Recipe? {
        guard let title = data["title"] as? String else {
            return nil
        }
        guard let shortDescription = data["shortDescription"] as? String else {
            return nil
        }
        guard let category = data["category"] as? String else {
            return nil
        }
        guard let difficulty = data["difficulty"] as? String else {
            return nil
        }
        guard let servings = data["servings"] as? String else {
            return nil
        }
        guard let instructions = data["instructions"] as? String else {
            return nil
        }
        guard let ingredients = data["ingredients"] as? [String] else {
            return nil
        }
        guard let imageURL = data["imageURL"] as? String else {
            return nil
        }
        
        return Recipe(title: title, shortDescription: shortDescription, category: category, difficulty: difficulty, servings: servings, instructions: instructions, ingredients: ingredients, imageURL: imageURL)
    }
    
    static let categories = [
        "Meats",
        "Vegetarian",
        "Mediterranean",
        "Soups",
        "Salads",
        "Desserts"
    ]
    
    static let difficulties = [
        "Easy",
        "Medium",
        "Difficult"
    ]
    
    static let exampleRecipes = [
        Recipe(title: "Pizza", shortDescription: "Pizza is delicious", category: "Mediterranean", difficulty: "Easy", servings: "4", instructions: "Make a pizza for 4 people", ingredients: ["Pizza Dough", "Toppings of choice"], imageURL: "Pizza"),
        Recipe(title: "Salad", shortDescription: "Salad is healthy", category: "Salads", difficulty: "Medium", servings: "2", instructions: "Put all the ingrediants in a bowl and add dressing", ingredients: ["Green leafs", "Vegetables of choice"], imageURL: "Salad")
    ]
}
