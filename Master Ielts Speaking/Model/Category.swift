//
//  Category.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-08.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * Model class for a Category
 *
 * - author: Amir
 * - version: 1
 *
 */
class Category : Object {
    ///category Name
    @objc dynamic var categoryName : String = ""
    ///category Image String format
    @objc dynamic var categoryImage : String = ""
    ///category Image Data
    @objc dynamic var categoryImageData : Data? = nil
    /// each category has list of words
    var words = List<Word>()
    
    override class func primaryKey() -> String {
        return "categoryName"
    }
  
}
