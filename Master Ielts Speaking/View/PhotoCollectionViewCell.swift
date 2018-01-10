//
//  PhotoCollectionViewCell.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-09.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit

/**
 * Cell of photo collection view which can be chosen for each category or word
 *
 * - author: Amir
 *
 */
class PhotoCollectionViewCell: UICollectionViewCell {
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        self.imageView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }

    override var isSelected: Bool {
        didSet {
            self.imageView.alpha = isSelected ? 0.3 : 1
        }
    }
}
