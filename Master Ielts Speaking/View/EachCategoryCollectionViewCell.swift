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
    
    @IBOutlet weak var wordImageView: UIImageView!
    @IBOutlet weak var wordField: UITextView!
    @IBOutlet weak var backgroundViewForText: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.cornerRadius = 15
        self.backgroundViewForText.layer.cornerRadius = 20
    }
    
    func setCell(withWord word : Word) {
        self.wordField.text = word.wordName
        if let imageData = word.wordImage {
            self.wordImageView.image = UIImage(data: imageData as Data)
        }
        if let imageString = word.wordImageString {
            self.wordImageView.image = UIImage(named: imageString)
        }
        
    }
    
    
    
    
}
