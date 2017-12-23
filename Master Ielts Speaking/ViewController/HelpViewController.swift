//
//  HelpViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-20.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController , WKNavigationDelegate{
    // Outlets
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        // create url
        let url = URL(string: "https://medium.com/@hashemi.eng1985/ielts-speaking-master-app-af7d23a02e34")
        // create request
        let request = URLRequest(url: url!)
        // load the page by the request
        webView.load(request)
        webView.navigationDelegate = self
        webView.addSubview(activityIndicator)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // stop animating activityIndicator when the page gets loaded
        self.activityIndicator.stopAnimating()
    }
    
    

}
