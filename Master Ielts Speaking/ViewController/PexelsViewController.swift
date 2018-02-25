//
//  PexelsViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2018-02-23.
//  Copyright © 2018 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import WebKit

class PexelsViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    static let myWebSite = "https://www.pexels.com"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        loadWebPage(webSite: PexelsViewController.myWebSite, webView: self.webView, viewController: self, activityIndicator: self.activityIndicator)
        // start animating activityIndicator
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // stop animating activityIndicator when the page gets loaded
        self.activityIndicator.stopAnimating()
    }
    
}
