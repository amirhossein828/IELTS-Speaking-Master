//
//  FirstViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-16.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    let test = ["envir","Friends"]

    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageControl.numberOfPages = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

 

}

extension FirstViewController :
UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return 2
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCellId", for: indexPath) as! FirstPageCollectionViewCell
            
            cell.imageView.image = UIImage(named: self.test[indexPath.row])
            return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // this method makes the page control dots white when the scrolling happen (target of collection view)
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        self.pageControl.currentPage = indexPath.item
    }
    
}

