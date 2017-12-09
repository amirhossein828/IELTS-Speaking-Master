//
//  EachCategoryCollectionViewCell.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-08.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit

class EachCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIView!
    
    @IBOutlet weak var wordField: UITextView!
    @IBOutlet weak var backgroundViewForText: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundViewForText.layer.cornerRadius = 20
    }
    
    
    
}
