//
//  HelpViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-20.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import WebKit

/**
 * web view screen to show the blog info
 *
 * - author: Amir
 *
 */
class HelpViewController: UIViewController , WKNavigationDelegate{
    // Outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // Properties
    static let myWebSite = "https://medium.com/@hashemi.eng1985/ielts-speaking-master-app-af7d23a02e34"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        loadWebPage(webSite: HelpViewController.myWebSite, webView: self.webView, viewController: self, activityIndicator: self.activityIndicator)
        // start animating activityIndicator
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Lock orientation
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // Back button
    @IBAction func backButton(_ sender: UIBarButtonItem) {
//        self.dismiss(animated: true, completion: nil)
        self.tabBarController?.view.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // stop animating activityIndicator when the page gets loaded
        self.activityIndicator.stopAnimating()
    }

}
