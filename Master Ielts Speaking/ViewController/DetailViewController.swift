//
//  DetailViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-09.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewPgeControl: UIView!
    @IBOutlet weak var advCollectionView: UICollectionView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    
    var definitionOfWordArray : List<String>? = nil
    var newVocabulary : Word? = nil
    var isComeFromInfo : Bool? = nil
    var isComeFromSearch : Bool = false
    var pageControlDots : Int = 0
    
    lazy var vc : AddNewWordViewController = {
        return self.parent as! AddNewWordViewController
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewPgeControl.isUserInteractionEnabled = false
        self.collectionView.backgroundColor = UIColor.clear
        self.wordLabel.text = self.newVocabulary?.wordName
        self.pageControl.numberOfPages = self.pageControlDots
        // make close button hidden if user come from search to this page
        _ = isComeFromSearch ? (self.closeButton.isHidden = true) : (self.closeButton.isHidden = false)
        
    }
    


    @IBAction func backButton(_ sender: UIButton) {
        if isComeFromInfo! {
            self.dismiss(animated: true, completion: nil)
        }else {
            vc.delegate?.reloadTableViewByNewData()
            vc.dismissThePage()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension DetailViewController :
UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
        return self.newVocabulary?.definitions.count ?? 0
        }else {
            return 2
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellOfDef", for: indexPath) as! DefinitionCollectionViewCell
        if let arrayOfDefenition = self.newVocabulary?.definitions {
            let wordDef = arrayOfDefenition[indexPath.row]
            cell.setCell(withIndex: indexPath, withDef: wordDef)
//        cell.definitionFieldCell.text = arrayOfDefenition[indexPath.row]
        }
        cell.backgroundColor = UIColor.clear
        return cell
        }else {
            let cellOfAdv = collectionView.dequeueReusableCell(withReuseIdentifier: "cellOfAd", for: indexPath) as! AdvertisementCell
            if let imageData = self.newVocabulary?.wordImage {
                cellOfAdv.imageView.image = UIImage(data: imageData as Data)
            }
            if let imageString = self.newVocabulary?.wordImageString {
                cellOfAdv.imageView.image = UIImage(named: imageString)
            }

            return cellOfAdv
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if collectionView == self.collectionView {
            return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
         }else {
            return CGSize(width: self.advCollectionView.frame.width, height: self.advCollectionView.frame.height)
        }
        
        
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
