//
//  EachCategoryCollectionViewCell.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-08.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit

/**
 * cell of Each CategoryCollectionView
 *
 * - author: Amir
 *
 */
class EachCategoryCollectionViewCell: UICollectionViewCell {
    // Outlets
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var wordImageView: UIImageView!
    @IBOutlet weak var wordField: UILabel!
    @IBOutlet weak var backgroundViewForText: UIView!
    // Properties
    weak var delegate : DeleteCellDelegate?
    var index  : IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "deleteCell")?.withRenderingMode(.alwaysTemplate)
        self.deleteButton.setImage(image, for: .normal)
        self.imageView.layer.cornerRadius = 15
        self.backgroundViewForText.layer.cornerRadius = 8
        self.imageView.layer.masksToBounds = true
    }
    
    func setCell(withWord word : Word, withIndex : IndexPath, shouldHidden : Bool) {
        self.index = withIndex
        self.deleteButton.isHidden = shouldHidden
        self.wordField.text = word.wordName
        if let imageData = word.wordImage {
            self.wordImageView.image = UIImage(data: imageData as Data)
        }
        if let imageString = word.wordImageString {
            self.wordImageView.image = UIImage(named: imageString)
        }
        
    }

    @IBAction func deleteButton(_ sender: UIButton) {
        self.delegate?.deleteCell(withIndex: index)
    }

}

// protocol to delegate deleting to InfoCollectionViewController
protocol DeleteCellDelegate : class {
    func deleteCell(withIndex : IndexPath)
}
