//
//  Word.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-09.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * Model class for a Word
 *
 * - author: Amir
 * - version: 1
 *
 */
class Word : Object {
    /// word Id
    @objc dynamic var wordId : String = UUID().uuidString
    /// word Name
    @objc dynamic var wordName : String = ""
    /// word Image data format
    @objc dynamic var wordImage : Data? = nil
    /// word Image String format
    @objc dynamic var wordImageString : String? = nil
    // definitions of the word
    var definitions = List<String>()
    // sentence examples of the word
    var examples = List<String>()
    // primary key
    override class func primaryKey() -> String {
        return "wordName"
    }
    
  
}
