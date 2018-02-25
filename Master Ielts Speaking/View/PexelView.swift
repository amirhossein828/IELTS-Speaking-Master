//
//  PexelView.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2018-02-25.
//  Copyright © 2018 seyedamirhossein hashemi. All rights reserved.
//

import UIKit

class PexelView: UIView {
    
    @IBOutlet var mainview: UIView!
    @IBOutlet weak var goPexelSiteOutlet: UIButton!
    
    weak var delegate : UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        Bundle.main.loadNibNamed("PexelView", owner: self, options: nil)
        addSubview(mainview)
        mainview.frame = self.bounds
        mainview.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }

    @IBAction func goPexel(_ sender: UIButton) {
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let pexelViewController = sb.instantiateViewController(withIdentifier: "PexelsViewController") as! PexelsViewController
        delegate?.show(pexelViewController, sender: delegate)
    }
}



