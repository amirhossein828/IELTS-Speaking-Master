//
//  Category.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-08.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var categoryId : String = UUID().uuidString
    @objc dynamic var categoryName : String = ""
    @objc dynamic var categoryImage : UIImage?
    
    override class func primaryKey() -> String {
        return "categoryId"
    }
    
    
    
    
    
    
}
