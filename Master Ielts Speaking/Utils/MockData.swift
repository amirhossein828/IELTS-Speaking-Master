//
//  mockData.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-10.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

/**
 * Class to load categories and words from json file and save in relam DB
 *
 * - author: Amir
 *
 *
 */
class MockData {
    
    /// #### Create names of categories
    /// This method Create names of categories and save in realm DB
    class func saveCategories() {
        let nameOfCategoriesArray = [CategoryName.Environment,CategoryName.friends,CategoryName.Book,CategoryName.HomeTown,CategoryName.Family]
        let nameOfImagesInAssets = ["envir","Friends","novel","cosmopolitan","family"]
        // create all category
        for count in 0..<nameOfCategoriesArray.count {
            let category = Category()
            category.categoryName = nameOfCategoriesArray[count]
            category.categoryImage = nameOfImagesInAssets[count]
            // save the in Realm
            saveData(category)
        }
    }
    
    /// #### loads the info from json file
    /// This method loads the info from json file and save in realm DB
    /// - Parameter: nameOfCategory - the name of category which this word should added to it.
    class func saveWords(nameOfCategory : String){
        if let path = Bundle.main.path(forResource: nameOfCategory, ofType: "json") {
            do {
                getImageAssets(path: path, completion: { (json) in
                    for count in 0..<2 {
                        let word = Word()
                        let wordName = json[count]["word"].string
                        word.wordName = wordName!
                        let arrayOfDefObjects = json[count]["definitions"].array
                        for defObject in arrayOfDefObjects! {
                            word.definitions.append(defObject["definition"].string!)
                        }
                        word.wordImageString = json[count]["imageNameInAssets"].string!
                        let examplesJson = json[count]["examples"].array
                        if let exampleJsonArray = examplesJson {
                            for example in exampleJsonArray {
                                word.examples.append(example.string!)
                            }
                        }
                        
                        saveData(word)
                        // update category by saying him new word
                        updateCategoryInDatabase(categoryName: nameOfCategory, word: word)
                    }
                })
  
            } catch {
                // handle error
            }
        }
    }
}


// category name for mock data
struct CategoryName {
    static let friends = "Friends"
    static let Environment = "Environment"
    static let Book = "Book"
    static let HomeTown = "HomeTown"
    static let Family = "Family"
}


