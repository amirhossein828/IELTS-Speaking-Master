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
    // Outlets
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewPgeControl: UIView!
    @IBOutlet weak var advCollectionView: UICollectionView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var examplePageControl: UIPageControl!
    @IBOutlet weak var exampleCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    // Properties
    var definitionOfWordArray : List<String>? = nil
    var newVocabulary : Word? = nil
    var isComeFromInfo : Bool = false
    var isComeFromSearch : Bool = false
    var pageControlDots : Int = 0
    var pageControlExampleDots : Int = 0
    // AddNewWordViewController object
    lazy var vc : AddNewWordViewController = {
        return parent as! AddNewWordViewController
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewPgeControl.isUserInteractionEnabled = false
        self.collectionView.backgroundColor = UIColor.clear
        self.wordLabel.text = self.newVocabulary?.wordName
        self.pageControl.numberOfPages = self.pageControlDots
        self.examplePageControl.numberOfPages = self.pageControlExampleDots
        // make close button hidden if user come from search to this page
        _ = (isComeFromSearch || isComeFromInfo) ? (self.closeButton.isHidden = true) : (self.closeButton.isHidden = false)
//        configureCloseButton()
        configureBackButton()
        if isComeFromInfo {
            self.navigationController?.navigationBar.isHidden = true
            self.backButton.isHidden = false
        }else {
            self.backButton.isHidden = true
        }
    }
    
    fileprivate func configureCloseButton() {
        let doneImage = UIImage(named: "done")?.withRenderingMode(.alwaysTemplate)
        self.closeButton.setImage(doneImage, for: .normal)
        self.closeButton.tintColor = UIColor.white
    }
    
    fileprivate func configureBackButton() {
        let backImage = UIImage(named: "ic_chevron_left_2x")?.withRenderingMode(.alwaysTemplate)
        self.backButton.setImage(backImage, for: .normal)
        self.backButton.tintColor = UIColor.white
    }
    


    @IBAction func backButton(_ sender: UIButton) {
        if isComeFromInfo {
            self.dismiss(animated: true, completion: nil)
        }else {
            vc.delegate?.reloadTableViewByNewData()
            vc.dismissThePage()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Lock orientation
    override open var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}

extension DetailViewController :
UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionView :
            let numberOfDefinitions = self.newVocabulary?.definitions.count ?? 0
            return min(numberOfDefinitions, 14)
        case self.advCollectionView :
            return 1
        default:
            let numberOfExamples = self.newVocabulary?.examples.count ?? 0
            return min(numberOfExamples, 14)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellOfDef", for: indexPath) as! DefinitionCollectionViewCell
        if let arrayOfDefenition = self.newVocabulary?.definitions {
            let wordDef = arrayOfDefenition[indexPath.row]
            cell.setCell(withIndex: indexPath, withDef: wordDef)
        }
        cell.backgroundColor = UIColor.clear
        return cell
        }else if collectionView == self.advCollectionView {
            let cellOfAdv = collectionView.dequeueReusableCell(withReuseIdentifier: "cellOfAd", for: indexPath) as! AdvertisementCell
            if let imageData = self.newVocabulary?.wordImage {
                cellOfAdv.imageView.image = UIImage(data: imageData as Data)
            }
            if let imageString = self.newVocabulary?.wordImageString {
                cellOfAdv.imageView.image = UIImage(named: imageString)
            }
            return cellOfAdv
        }else {
            let cellOfExample = collectionView.dequeueReusableCell(withReuseIdentifier: "cellOfExample", for: indexPath) as! ExampleCollectionViewCell
            if let arrayOfExamples = self.newVocabulary?.examples {
                let wordExample = arrayOfExamples[indexPath.row]

                        cellOfExample.exampleLabel.text = wordExample
            }
            cellOfExample.backgroundColor = UIColor.clear
            return cellOfExample
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if collectionView == self.collectionView {
            return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
         }else if collectionView == self.advCollectionView {
            return CGSize(width: self.advCollectionView.frame.width, height: self.advCollectionView.frame.height)
         } else {
             return CGSize(width: self.exampleCollectionView.frame.width, height: self.exampleCollectionView.frame.height)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // this method makes the page control dots white when the scrolling happen (target of collection view)
     func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        if scrollView == self.collectionView {
            let indexPath = NSIndexPath(item: Int(index), section: 0)
            self.pageControl.currentPage = indexPath.item
        }else if scrollView == self.exampleCollectionView {
            let indexPath = NSIndexPath(item: Int(index), section: 0)
            self.examplePageControl.currentPage = indexPath.item
        }
        
    }
    
    

}
