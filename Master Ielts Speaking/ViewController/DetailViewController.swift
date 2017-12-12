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
    var definitionOfWordArray : List<String>? = nil
    var newVocabulary : Word? = nil
    var isComeFromInfo : Bool? = nil
    
    lazy var vc : AddNewWordViewController = {
        return self.parent as! AddNewWordViewController
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewPgeControl.isUserInteractionEnabled = false
        self.collectionView.backgroundColor = UIColor.clear
       
        
    }
    


    @IBAction func backButton(_ sender: UIButton) {
        if isComeFromInfo! {
            self.dismiss(animated: true, completion: nil)
        }else {
            vc.dismissThePage()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    

}
