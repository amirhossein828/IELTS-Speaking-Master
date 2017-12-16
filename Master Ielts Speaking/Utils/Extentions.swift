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

extension UIViewController {

func showAlert(_ title: String, _ message: String, completion: (()->())? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertActionStyle.default,
                                  handler: { (_) -> Void in
                                    alert.dismiss(animated: true, completion: nil)
                                    DispatchQueue.main.async {
                                        completion?()
                                    }
    }))
    self.present(alert, animated: true, completion: nil)
 }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
// Lock orientation
extension UINavigationController {
    open override var shouldAutorotate: Bool {
        return visibleViewController!.shouldAutorotate
    }
}


