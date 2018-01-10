//
//  QwantApiService.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-17.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/**
 * Get photos from Qwant API
 *
 * - author: AmirHossein
 */
class QwantApiService {
    
    /// Ask for seachKey and get the photos from Flickr website.
    ///
    /// - Parameters:
    ///   - searchKey: the searchKey
    ///   - completion: the completion to invoke when success (the photos recieved)
    class func getPhotos(searchKey : String,completion : @escaping (DataResponse<Any>) -> Void) {
        let encodeSearchString = searchKey.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString  = "https://api.qwant.com/api/search/images?count=30&offset=1&q="+encodeSearchString!
        Alamofire.request(urlString).responseJSON { (response) in
            completion(response)
        }
    }
 
}
