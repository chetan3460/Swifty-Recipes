//
//  FirebaseHelper.swift
//  Swifty Recipes
//
//  Created by Frank Ehlers on 15.10.17.
//  Copyright © 2017 Frank Ehlers. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

enum FirebaseStrings {
    static let postDirectory = "posts"
    static let imageDirectory = "images"
}

enum FirebaseHelper {
    private static let databaseReference = Database.database().reference()
    private static let storageReference = Storage.storage().reference()
    static let postReference = databaseReference.child(FirebaseStrings.postDirectory)
    
    private static func createEntry(from recipe: Recipe, by userID: String) -> Dictionary<String, AnyObject> {
        let recipeData: Dictionary<String, AnyObject> = [
            "title": recipe.title as AnyObject,
            "shortDescription": recipe.shortDescription as AnyObject,
            "category": recipe.category as AnyObject,
            "difficulty": recipe.difficulty as AnyObject,
            "servings": recipe.servings as AnyObject,
            "instructions": recipe.instructions as AnyObject,
            "ingredients": recipe.ingredients as AnyObject,
            "imageURL": recipe.imageURL as AnyObject,
            "timeStamp": Date().timeIntervalSince1970 as AnyObject,
            "userID": userID as AnyObject
        ]
        return recipeData
        
    }
    
    static func saveDatabaseEntry(to directory: String, with recipe: Recipe, by user: String, completion: @escaping(Bool)->()) {
        let directoryReference = databaseReference.child(directory)
        let recipeData = createEntry(from: recipe, by: user)
        let newEntry = directoryReference.childByAutoId()
        newEntry.setValue(recipeData) { (error, reference) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
    
    static func upload(image: UIImage, to directory: String, completion: @escaping (URL?)->()) {
        guard let imageData = UIImageJPEGRepresentation(image, 0.2) else {
            completion(nil)
            return
        }
        let uploadStorageRefernce = storageReference.child(directory)
        let imgID = NSUUID().uuidString
        let metaData = StorageMetadata()
        metaData.contentType = "images/jpeg"
        
        var downloadURL: URL?
        
        _ = uploadStorageRefernce.child(imgID).putData(imageData, metadata: metaData, completion: { (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else {
                guard let metadata = metadata else {
                    completion(nil)
                    return
                }
                guard let url = metadata.downloadURL() else {
                    completion(nil)
                    return
                }
                downloadURL = url
                completion(downloadURL)
            }
        })
        
    }
    
    static func downloadImage(for url: String, completion: @escaping (UIImage)->()) {
        let imageStorageReference = Storage.storage().reference(forURL: url)
        _ = imageStorageReference.getData(maxSize: 1*1024*1024, completion: { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let image = UIImage(data: data!) {
                    completion(image)
                }
            }
        })
    }
    
}



