//
//  DetailViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-09.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import RealmSwift

/**
 * Detail information of each words screen
 *
 * - author: Amir
 *
 */
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
    @IBOutlet weak var photoContainerView: UIView!
    // Properties
    var definitionOfWordArray : List<String>? = nil
    var newVocabulary : Word? = nil
    var isComeFromInfo : Bool = false
    var isComeFromSearch : Bool = false
    var pageControlDots : Int = 0
    var pageControlExampleDots : Int = 0
    var isComeFromCamera: Bool = false
    /// AddNewWordViewController object
    lazy var vc : AddNewWordViewController = {
        return parent as! AddNewWordViewController
        }()
    /// top label to show the name of word
    let topView : UILabel = {
        let topView = UILabel()
        topView.textColor = UIColor.white
        topView.font = UIFont.boldSystemFont(ofSize: 26)
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
    }()
    /// button to restart song
    let doneButton : UIButton =  {
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        return doneButton
    }()
    /// set uo the top label layout
    private func setTopViewLayout() {
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewPgeControl.isUserInteractionEnabled = false
        self.collectionView.backgroundColor = UIColor.clear
        self.pageControl.numberOfPages = self.pageControlDots
        self.examplePageControl.numberOfPages = self.pageControlExampleDots
        // make close button hidden if user come from search to this page
//        _ = (isComeFromSearch || isComeFromInfo) ? (self.closeButton.isHidden = true) : (self.closeButton.isHidden = false)
//        configureCloseButton()
        configureBackButton()
        showTopView()
    }
    
    /// check user come from Add.
    fileprivate func showTopView() {
        if (isComeFromSearch || isComeFromInfo) == false {
            view.addSubview(topView)
            view.addSubview(doneButton)
            setTopViewLayout()
            topView.bringSubview(toFront: photoContainerView)
            topView.text = self.newVocabulary?.wordName
            photoContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
            doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        }else {
            self.navigationItem.title = self.newVocabulary?.wordName
        }
    }
    
    @objc private func doneButtonPressed() {
        if isComeFromCamera {
            self.dismiss(animated: true, completion: nil)
        }else {
            vc.delegate?.reloadTableViewByNewData()
            vc.dismissThePage()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if isComeFromSearch {
//            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            
            setNeedsFocusUpdate()
        }
    }
    // configure CloseButton
    fileprivate func configureCloseButton() {
        let doneImage = UIImage(named: "done")?.withRenderingMode(.alwaysTemplate)
        self.closeButton.setImage(doneImage, for: .normal)
        self.closeButton.tintColor = UIColor.white
    }
    // configure BackButton
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

/// Extend to implenet collection view
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
            return cellOfDefinitions(collectionView, indexPath)
        }else if collectionView == self.advCollectionView {
            return cellOfAdvertisement(collectionView, indexPath)
        }else {
            return cellOfExamples(collectionView, indexPath)
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
    /// cell Of Advertisement
    ///
    /// - Parameters:
    ///   - collectionView: the collectionView
    ///   - indexPath: the indexPath
    ///   - Returns: cell for Advertisement
    fileprivate func cellOfAdvertisement(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cellOfAdv = collectionView.dequeueReusableCell(withReuseIdentifier: "cellOfAd", for: indexPath) as! AdvertisementCell
        if let imageData = self.newVocabulary?.wordImage {
            cellOfAdv.imageView.image = UIImage(data: imageData as Data)
        }
        if let imageString = self.newVocabulary?.wordImageString {
            cellOfAdv.imageView.image = UIImage(named: imageString)
        }
        return cellOfAdv
    }
    
    /// cell Of Definitions
    ///
    /// - Parameters:
    ///   - collectionView: the collectionView
    ///   - indexPath: the indexPath
    ///   - Returns: cell for Definitions
    fileprivate func cellOfDefinitions(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellOfDef", for: indexPath) as! DefinitionCollectionViewCell
        if let arrayOfDefenition = self.newVocabulary?.definitions {
            let wordDef = arrayOfDefenition[indexPath.row]
            cell.setCell(withIndex: indexPath, withDef: wordDef)
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    /// cell Of Examples
    ///
    /// - Parameters:
    ///   - collectionView: the collectionView
    ///   - indexPath: the indexPath
    ///   - Returns: cell for Examples
    fileprivate func cellOfExamples(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cellOfExample = collectionView.dequeueReusableCell(withReuseIdentifier: "cellOfExample", for: indexPath) as! ExampleCollectionViewCell
        if let arrayOfExamples = self.newVocabulary?.examples {
            let wordExample = arrayOfExamples[indexPath.row]
            cellOfExample.exampleLabel.text = wordExample
        }
        cellOfExample.backgroundColor = UIColor.clear
        return cellOfExample
    }

}
