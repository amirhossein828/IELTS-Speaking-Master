//
//  DatabaseManager.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-08.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import Foundation
import RealmSwift


// MARK: - Save Data

/// #### save Data on Realm DB
/// This method saves data on Realm DB
/// - Parameter: model - Type of model to be read from Realm DB
public func saveData<T:Object>(_ object: T) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(object, update: true)
    }
}

// MARK: - Read Data

/// #### Read Data from Realm DB
/// This method reads data from Realm DB and returns with completion block
/// - Parameter: model - Type of model to be read from Realm DB
/// - Parameter: predicate - predicate string such as "color = 'tan' AND name BEGINSWITH 'B'"
/// - Parameter: completion: completion handler closure to return data
/// - Returns: It is Void since it uses completion for call backs
public func readData<T:Object>(_ model: T.Type, predicate: String?, completion: (_ responseData:Results<T>) -> Void) {
    let realm = try! Realm()
    let result: Results<T>
    if let predicateString = predicate {
        result = realm.objects(model).filter(predicateString)
    } else {
        result = realm.objects(model)
    }
    completion(result)
    
    
}

// MARK: - Delete

/// #### Delete a model from Realm DB
/// This method deletes a specific model from Realm DB
/// - Parameter: model - type of the model that is subclass of a Object and will be deleted
public func deleteFromDatadase<T:Object>(_ model: T) {
    let realm = try! Realm()
    
    try! realm.write {
        
        realm.delete(model)
        
    }
}

/// #### Delete All
/// This method deletes all objects from Realm DB
/// - Important: Be cautious when using it, data will not be recoverable!
public func deleteAll() {
    let realm = try! Realm()
    try! realm.write {
        realm.deleteAll()
    }
}

// MARK: - Update


/// #### Update words in catergory
/// This method updates objects from Realm DB
/// - Parameter: categoryName - The name of category which new word wants to be updated on it. word - The new word which wnates to be added to this category
func updateCategoryInDatabase(categoryName: String, word : Word) {
    let realm = try! Realm()
    
    readData(Category.self, predicate: nil) { (resultCategories) in
        for category in resultCategories {
            if category.categoryName == categoryName {
                try! realm.write {
                category.words.append(word)
                realm.add(category, update: true)
                }
            }
        }
    }
    

}
