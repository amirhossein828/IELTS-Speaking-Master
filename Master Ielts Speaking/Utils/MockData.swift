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


class MockData {
    

    class func saveCategories() {
        let nameOfCategoriesArray = [CategoryName.Environment,CategoryName.friends,CategoryName.Book,CategoryName.HomeTown]
        let nameOfImagesInAssets = ["envir","Friends","novel","poverty"]
        // create all category
        for count in 0..<nameOfCategoriesArray.count {
            let category = Category()
            category.categoryName = nameOfCategoriesArray[count]
            category.categoryImage = nameOfImagesInAssets[count]
            // save the in Realm
            saveData(category)
        }
    }
    
    class func saveWords(nameOfCategory : String){
//        let nameOfImagesInAssets = ["envir","Friends"]
        
        print(nameOfCategory)
        if let path = Bundle.main.path(forResource: nameOfCategory, ofType: "json") {
            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                let json = try JSON(data : data)
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

struct CategoryName {
    static let friends = "Friends"
    static let Environment = "Environment"
    static let Book = "Book"
    static let HomeTown = "HomeTown"
}

func getImageAssets(path : String, completion :  (JSON) -> Void){
    
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        print(data)
    let json = try JSON(data : data)
    
    
        completion(json)
        
    } catch {
        print("fucking errrooorrrrrrrooooooooo")
    }
    
    
    
    
}
