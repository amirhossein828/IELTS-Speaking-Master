//
//  CategoryTableViewCell.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-08.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCustomView: UIView!
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundCustomView.layer.shadowColor = UIColor.black.cgColor
        self.backgroundCustomView.layer.shadowRadius = 10
        self.backgroundCustomView.layer.shadowOffset = CGSize.zero
        self.backgroundCustomView.layer.opacity = 1
            self.backgroundCustomView.layer.cornerRadius = 17
        self.categoryImage.layer.cornerRadius = 50
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
