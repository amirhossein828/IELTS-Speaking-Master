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
    class func getDefinitionOfVocabulary(word : String,arrayOfWordsDefinition : @escaping ([String]?) -> Void) {
        let wordtrim = word.trimmingCharacters(in: .whitespacesAndNewlines)
        let wordEncode = wordtrim.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "https://wordsapiv1.p.mashape.com/words/"+wordEncode!+"/definitions"
        let url = URL(string: urlString)
        Alamofire.request(url!, method: .get, parameters: nil, encoding:JSONEncoding.default , headers: headers).responseJSON { (response) in
            // create array of string (the definition of word)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let arrayOfDefObjects = json["definitions"].array else {
                    arrayOfWordsDefinition(nil)
                    return
                }
                var arrayOfWordsDefinitionString = [String]()
                for object in arrayOfDefObjects {
                    arrayOfWordsDefinitionString.append(object["definition"].string!)
                }
                arrayOfWordsDefinition(arrayOfWordsDefinitionString)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    /// Get the examples of words for specific word
    ///
    /// - Parameters:
    ///   - word: the word
    ///   - completion: the completion to invoke when success (the examples recieved)
    class func getExampleOfVocabulary(word : String,arrayOfExample : @escaping ([String]?) -> Void) {
        let wordtrim = word.trimmingCharacters(in: .whitespacesAndNewlines)
        let wordEncode = wordtrim.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "https://wordsapiv1.p.mashape.com/words/"+wordEncode!+"/examples"
        let url = URL(string: urlString)
        Alamofire.request(url!, method: .get, parameters: nil, encoding:JSONEncoding.default , headers: headers).responseJSON { (response) in
            // create array of string (the definition of word)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let arrayOfExamObjects = json["examples"].array else {
                    arrayOfExample(nil)
                    return
                }
                var arrayOfWordsExampleString = [String]()
                for object in arrayOfExamObjects {
                    arrayOfWordsExampleString.append(object.string!)
                }
                arrayOfExample(arrayOfWordsExampleString)
            case .failure(let error):
                print(error)
            }
        }
    }
    
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
    
    class func getDefinitionAndExamples(viewController: UIViewController?, word : String,arrayOfWordsDefinition : @escaping ([String]) -> Void,
              arrayOfExample : @escaping ([String]) -> Void,
              failur : @escaping (_ massege : String) -> Void) {
        let wordtrim = word.trimmingCharacters(in: .whitespacesAndNewlines)
        let wordEncode = wordtrim.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "https://wordsapiv1.p.mashape.com/words/"+wordEncode!+"/definitions"
        let url = URL(string: urlString)
        Alamofire.request(url!, method: .get, parameters: nil, encoding:JSONEncoding.default , headers: headers).responseJSON {
            [weak viewController] (response) in
            // create array of string (the definition of word)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let arrayOfDefObjects = json["definitions"].array else {
                    DispatchQueue.main.async {
                        viewController?.showAlert("Enter a valid word", "There is no meaning for this word")
                    }
                    
                    return
                }
                var arrayOfWordsDefinitionString = [String]()
                for object in arrayOfDefObjects {
                    arrayOfWordsDefinitionString.append(object["definition"].string!)
                }
                arrayOfWordsDefinition(arrayOfWordsDefinitionString)
            case .failure(let error):
                failur(error.localizedDescription)
                print(error.localizedDescription)
            }
        }
        let urlStringEx = "https://wordsapiv1.p.mashape.com/words/"+wordEncode!+"/examples"
        let urlEx = URL(string: urlStringEx)
        Alamofire.request(urlEx!, method: .get, parameters: nil, encoding:JSONEncoding.default , headers: headers).responseJSON {
            [weak viewController](response) in
            // create array of string (the definition of word)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let arrayOfExamObjects = json["examples"].array else {
                    viewController?.showAlert("Enter a valid word", "There is no meaning for this word")
                    return
                }
                var arrayOfWordsExampleString = [String]()
                for object in arrayOfExamObjects {
                    arrayOfWordsExampleString.append(object.string!)
                }
                arrayOfExample(arrayOfWordsExampleString)
            case .failure(let error):
                print(error)
            }
        }
    }
   
}

