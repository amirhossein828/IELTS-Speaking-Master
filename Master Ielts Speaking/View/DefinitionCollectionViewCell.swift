//
//  DefinitionCollectionViewCell.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-10.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit

class DefinitionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var definitionFieldCell: UILabel!
    
    
    override func awakeFromNib() {
    }
    
    func setCell(withIndex index : IndexPath, withDef definition : String) {
        self.definitionFieldCell.text = definition
    }
    
    
}
