//
//  mockData.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-10.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import Foundation
import RealmSwift


class MockData {
    

    class func saveCategories() {
        let nameOfCategoriesArray = ["Environment","Friends"]
        let nameOfImagesInAssets = ["envir","Friends"]
        // create all category
        for count in 0..<2 {
            let category = Category()
            category.categoryId = String(count)
            category.categoryName = nameOfCategoriesArray[count]
            category.categoryImage = nameOfImagesInAssets[count]
            // save the in Realm
            saveData(category)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}
