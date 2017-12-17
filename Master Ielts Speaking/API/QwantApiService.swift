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

class QwantApiService {
    
    // method which ask for seachKey and get the photos from Qwant website.
    class func getPhotos(searchKey : String,completion : @escaping (DataResponse<Any>) -> Void) {
//        let encodeSearchString = searchKey.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString  = "https://api.qwant.com/api/search/images?count=30&offset=1&q="+searchKey
        Alamofire.request(urlString).responseJSON { (response) in
            completion(response)
        }
        
    }
 
}
