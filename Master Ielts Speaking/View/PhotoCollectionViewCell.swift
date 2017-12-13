//
//  PhotoCollectionViewCell.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-09.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            self.imageView.alpha = isSelected ? 0.3 : 1
        }
    }
}