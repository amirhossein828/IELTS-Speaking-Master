//
//  CustomLayout.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-13.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit


protocol CustomLayoutDelegate: class {
    // Method to ask the delegate for the height of the image
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}

class CustomLayout : UICollectionViewLayout {
    weak var delegate: CustomLayoutDelegate!
    
    // properties
    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 3
    
    // Array to keep a cache of attributes.
    var cache = [UICollectionViewLayoutAttributes]()
    
    // Content height and size
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    //  During each layout update, the collection view calls this method first to give your layout object a chance to prepare for the upcoming layout operation.
    override func prepare() {
        //  Only calculate once
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        // Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        // One array with two 0 on it
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        // Iterates through the list of items in the first section
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            // Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
            let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            let height = cellPadding * 2 + photoHeight + 120
            // contains the location and dimensions of a rectangle
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            //  Creates an UICollectionViewLayoutItem with the frame and add it to the cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // Updates the collection view content height
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    // The attributed which has been created in prepare method and saved in cache, now with this method would be given to the layout.
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    // Returns the layout attributes for the item at the specified index path.
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

}
