//
//  WordsApiService.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-10.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/**
 * Get definitions from WordsApiService
 *
 * - author: AmirHossein
 */
class WordsApiService {
    
    static let headers: HTTPHeaders = [
        "X-Mashape-Key": "9GUEoeCNaEmshOp3PfV7jivYl4YRp1faus3jsnRh8AwhK0LACA",
        "Accept": "application/json"
    ]
    
    /// Get the definition of words for specific word
    ///
    /// - Parameters:
    ///   - word: the word
    ///   - completion: the completion to invoke when success (the definitions recieved)
    class func getDefinitionOfWords(word : String,completion : @escaping (DataResponse<Any>) -> Void) {
        let wordtrim = word.trimmingCharacters(in: .whitespacesAndNewlines)
        let wordEncode = wordtrim.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "https://wordsapiv1.p.mashape.com/words/"+wordEncode!+"/definitions"
        let url = URL(string: urlString)
        Alamofire.request(url!, method: .get, parameters: nil, encoding:JSONEncoding.default , headers: headers).responseJSON { (response) in
            completion(response)
        }
    }
    
    /// Get the examples of words for specific word
    ///
    /// - Parameters:
    ///   - word: the word
    ///   - completion: the completion to invoke when success (the examples recieved)
    class func getExampleOfWords(word : String,completion : @escaping (DataResponse<Any>) -> Void) {
        let wordtrim = word.trimmingCharacters(in: .whitespacesAndNewlines)
        let wordEncode = wordtrim.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "https://wordsapiv1.p.mashape.com/words/"+wordEncode!+"/examples"
        let url = URL(string: urlString)
        Alamofire.request(url!, method: .get, parameters: nil, encoding:JSONEncoding.default , headers: headers).responseJSON { (response) in
            completion(response)
        }
    }
    
//    class func getDefinitionAndExamples(word : String,completion : @escaping (DataResponse<Any>) -> Void) {
//        let wordtrim = word.trimmingCharacters(in: .whitespacesAndNewlines)
//        let wordEncode = wordtrim.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        let urlString = "https://wordsapiv1.p.mashape.com/words/"+wordEncode!+"/definitions"
//        let url = URL(string: urlString)
//        Alamofire.request(url!, method: .get, parameters: nil, encoding:JSONEncoding.default , headers: headers).responseJSON { (response) in
//            // create array of string (the definition of word)
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                guard let arrayOfDefObjects = json["definitions"].array else {
//                    viewController.showAlert("Enter a valid word", "There is no meaning for this word")
//                    return
//                }
//                arrayOfDefObject(arrayOfDefObjects)
//            case .failure(let error):
//                failur(error.localizedDescription)
//                print(error.localizedDescription)
//            }
//            completion(response)
//    }
   
}

