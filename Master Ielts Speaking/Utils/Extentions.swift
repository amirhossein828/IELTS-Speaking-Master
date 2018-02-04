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

/**
 A set of helpful extensions for classes from UIKit
 */

/**
 * Extends UIImageView to download photos.
 *
 * - author: Amirhossein
 *
 */
extension UIImageView {
    
    /// Download images ( It uses caching to avoid reloading photos )
    ///
    /// - Parameters:
    ///   - url: the url of photo
    ///   - contentMode: the contentMode
    ///   - completion: the completion to invoke when success (the photo recieved)
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, completion : @escaping () -> Void) {
        if let image = imageCacheNew.object(forKey: url as AnyObject) {
            self.image = image
            completion()
        }else {
            Alamofire.request(url).response { (response) in
                if let data = response.data {
                    if let image = UIImage(data: data, scale: 0.1) {
                    imageCacheNew.setObject(image, forKey: url as AnyObject )
                    DispatchQueue.main.async {
                        self.image = image
                        completion()
                    }
                    }
                    
                }
            }
        }
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, completion : @escaping () -> Void) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode, completion : completion)
    }
}

/**
 * Extends UIViewController to show alert.
 *
 * - author: Amirhossein
 *
 */
extension UIViewController {

    /// show alert
    ///
    /// - Parameters:
    ///   - title: the title of alert
    ///   - message: the message of alert
    ///   - completion: the completion to invoke when success
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

/**
 * Extends UIViewController to hide Keyboard When Tapped Around.
 *
 * - author: Amirhossein
 *
 */
extension UIViewController {
    /// hide Keyboard When user Tapped Around of keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

/**
 * Extends UINavigationController to Lock orientation.
 *
 * - author: Amirhossein
 *
 */
//extension UINavigationController {
//    open override var shouldAutorotate: Bool {
//        return visibleViewController!.shouldAutorotate
//    }
//}




