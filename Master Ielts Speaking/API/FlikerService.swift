//
//  FlikerService.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-09.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import Foundation
import Alamofire


// url :  https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=4b3d24be51612f9da5c643b7a43947a6&text=book&extras=url_m&format=rest
// apikey : d12b820ce8b0fde8f7fe8dcfa87c28e5

class FlickrService {
    
    // method which ask for seachKey and get the photos from Flickr website.
    class func getPhotos(searchKey : String,completion : @escaping (DataResponse<Any>) -> Void) {
        let apiKey = "d12b820ce8b0fde8f7fe8dcfa87c28e5"
        let URL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key="+apiKey+"&text=\(searchKey)&extras=url_m&format=json&nojsoncallback=1"
        print("******************************")
        print(URL)
        Alamofire.request(URL).responseJSON { (response) in
            completion(response)
        }
    }
    
    
    
    
    
    
    
    
}

