//
//  HelpViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-20.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {
    // Outlets
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create url
        let url = URL(string: "https://medium.com/@hashemi.eng1985/splash-screen-with-custom-dots-framework-9ed737a17770")
        // create request
        let request = URLRequest(url: url!)
        // load the page by the request
        webView.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Back button
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
