//
//  Extentions.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-10.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import Foundation
import Alamofire
import UIKit


extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        if let image = imageCacheNew.object(forKey: url as AnyObject) {
            self.image = image
        }else {
            Alamofire.request(url).response { (response) in
                if let data = response.data {
                    let image = UIImage(data: data)
                    imageCacheNew.setObject(image!, forKey: url as AnyObject )
                    DispatchQueue.main.async {
                        self.image = image
                    }
                    
                }
            }
        }
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
