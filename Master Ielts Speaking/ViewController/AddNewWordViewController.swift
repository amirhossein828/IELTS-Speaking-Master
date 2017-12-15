//
//  AddNewWordViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-09.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

// It will avoid reloading photos during scrolling
var imageCacheNew = NSCache<AnyObject, UIImage>()

class AddNewWordViewController: UIViewController {
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var newWord: UITextView!
    @IBOutlet weak var textViewBackGround: UIView!
    @IBOutlet weak var addNewWordButton: UIButton!
    @IBOutlet weak var dismissScreen: UIButton!
    
    // properties
    var arrayOfPhotos : [JSON]? = nil
    var arrayOfDefString = [String]()
    var newVocab : Word? = nil
    var category : Category? = nil
    var imageSelected : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.containerView)
        self.containerView.isHidden = true
        self.collectionView.layer.borderColor = UIColor.white.cgColor
        self.textViewBackGround.layer.cornerRadius = 8
        self.textViewBackGround.layer.masksToBounds = true
        self.newWord.layer.cornerRadius = 8
        let closeImageButton = UIImage(named: "close")!.withRenderingMode(.alwaysTemplate)
        self.dismissScreen.setImage(closeImageButton, for: .normal)
        self.dismissScreen.imageView?.tintColor = UIColor.white
        self.addNewWordButton.layer.cornerRadius = 7
        self.collectionView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 3)
    }
    
    @IBAction func dismissScreen(_ sender: UIButton) {
        dismissThePage()
    }
    
    
    @IBAction func addNewWordButton(_ sender: UIButton) {
        // create word object
        newVocab = Word()
        // give the nameofWord property to it
        newVocab?.wordName = self.newWord.text
        // Get difinitions and examples of the newWord from Web Service
        WordsApiService.getDefinitionOfWords(word: (newVocab?.wordName)!) { (response) in
            // create array of string (the definition of word)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let arrayOfDefObjects = json["definitions"].array
                for object in arrayOfDefObjects! {
                    self.newVocab?.definitions.append(object["definition"].string!)
                    
                }

            case .failure(let error):
                print(error)
            }
        }
        // search for photos related to the new word
        FlickrService.getPhotos(searchKey: (newVocab?.wordName)!) { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                DispatchQueue.main.async {
                    self.arrayOfPhotos = json["photos"]["photo"].array
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
    
        }
        // show the photos inside the collection view
    }
    // come back to list of categories
    func dismissThePage() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func nextButton(_ sender: UIButton) {
        // save in database
        saveData(newVocab!)
        updateCategoryInDatabase(categoryName: (self.category?.categoryName)!, word: newVocab!)
        let detailViewController = self.childViewControllers[0] as! DetailViewController
        detailViewController.newVocabulary = self.newVocab
        detailViewController.wordLabel.text = detailViewController.newVocabulary?.wordName
        detailViewController.isComeFromInfo = false
        // go to detail page
        UIView.transition(from: self.mainView, to: self.containerView, duration: 1.2, options: [.transitionFlipFromLeft,.showHideTransitionViews]){
            (succed) in
            if succed {
                detailViewController.pageControl.numberOfPages = (self.newVocab?.definitions.count)!
                detailViewController.collectionView.reloadData()
                detailViewController.advCollectionView.reloadData()
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



extension AddNewWordViewController : UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayOfPhotos?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PhotoCollectionViewCell
        
        if let imageUrl = self.arrayOfPhotos![indexPath.row]["url_m"].string {
            cell.imageView.downloadedFrom(link: imageUrl)
        }
        cell.imageView.layer.cornerRadius = 7
        return cell
    }
    
    // select one cell and change the color of it
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoCell = self.collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        let imageCell = photoCell.imageView.image
        self.newVocab?.wordImage = UIImageJPEGRepresentation(imageCell!, 0.4)
        
    }
    
//     make the size of each cell half of the screen
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (collectionView.frame.width - 9)/3, height: self.view.frame.size.height * 0.15)
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
 
}


