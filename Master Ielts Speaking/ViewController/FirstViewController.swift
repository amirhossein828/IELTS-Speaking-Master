//
//  FirstViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-16.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
<<<<<<< HEAD
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    let test = ["cat1","cat2","cat3","cat4","cat5"]
    let titles = ["Make New Category","Add New Words","See Definition","See Photo","See Example"]
    let descriptionOfTitle = ["By making new categories you would be able to add new words which just related to the category","By adding new words to each category it is possible to collect all words related to each category","The definition of words appear when new word got added","The photo of words appear when new word got added","The examples of words appear when new word got added"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageControl.numberOfPages = 5
        let icon =  UIImage(named: "icon3")?.withRenderingMode(.alwaysTemplate)
        self.iconImage.image = icon
        self.iconImage.tintColor = UIColor.white
=======
    let test = ["envir","Friends"]

    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageControl.numberOfPages = 2
>>>>>>> 28830c06c670ce70b78f3e58b18a50c50244c914
        
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
        
<<<<<<< HEAD
            return 5
=======
            return 2
>>>>>>> 28830c06c670ce70b78f3e58b18a50c50244c914
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCellId", for: indexPath) as! FirstPageCollectionViewCell
            cell.imageView.image = UIImage(named: self.test[indexPath.row])
<<<<<<< HEAD
            cell.title.text = self.titles[indexPath.row]
            cell.descriptionLabel.text = self.descriptionOfTitle[indexPath.row]
=======
>>>>>>> 28830c06c670ce70b78f3e58b18a50c50244c914
            return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
<<<<<<< HEAD
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
=======
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
>>>>>>> 28830c06c670ce70b78f3e58b18a50c50244c914
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

