//
//  Word.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-09.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import Foundation
import RealmSwift


class Word : Object {
    @objc dynamic var wordId : String = UUID().uuidString
    @objc dynamic var wordName : String = ""
    @objc dynamic var wordImage : NSData? = nil
    var definitions = List<String>()
    var examples = List<String>()
    
    override class func primaryKey() -> String {
        return "wordId"
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
