//
//  HelperFunctions.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-15.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


// This method does gives the array of defenition in json object format.
func getDefinitionsAndPhotos(withWord word : String,viewController : UIViewController , arrayOfDefObject : @escaping ([JSON]) -> Void ) {
    WordsApiService.getDefinitionOfWords(word: word) { (response) in
        // create array of string (the definition of word)
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            guard let arrayOfDefObjects = json["definitions"].array else {
                viewController.showAlert("Enter a valid word", "There is no meaning for this word")
                return
            }
            arrayOfDefObject(arrayOfDefObjects)
        case .failure(let error):
            print(error)
        }
    }
    
}
