//
//  PexelsService.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2018-02-23.
//  Copyright © 2018 seyedamirhossein hashemi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


// url :  https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=4b3d24be51612f9da5c643b7a43947a6&text=book&extras=url_m&format=rest

// url :  https://api.pexels.com/v1/search?query=example+query&per_page=15&page=1
// apikey : 563492ad6f9170000100000139781f4f90a844d9a238dffa3ea1d20c



/**
 * Get photos from Flickr API
 *
 * - author: AmirHossein
 */
class PexelsService {
    
    /// Ask for seachKey and get the photos from Flickr website.
    ///
    /// - Parameters:
    ///   - searchKey: the searchKey
    ///   - completion: the completion to invoke when success (the photos recieved)
    class func getPhotosPexels(searchKey : String,completion : @escaping (DataResponse<Any>) -> Void) {
        let trimmedSearchKey = searchKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let searchEncode = trimmedSearchKey.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let apiKey = "563492ad6f9170000100000139781f4f90a844d9a238dffa3ea1d20c"
        let URLPexels = "https://api.pexels.com/v1/search?query=\(searchEncode!)&per_page=20&page=1"
        let token = apiKey
        let Auth_header = [ "Authorization" : token]
        Alamofire.request(URLPexels, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Auth_header).validate().responseJSON { (response) in
            completion(response)
        }
    }
    
    
}



