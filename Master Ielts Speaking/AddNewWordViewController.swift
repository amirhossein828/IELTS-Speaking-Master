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
    // properties
    var arrayOfPhotos : [JSON]? = nil
    var arrayOfDefString = [String]()
    var newVocab : Word? = nil
    var category : Category? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.containerView)
        self.containerView.isHidden = true
        self.collectionView.layer.borderColor = UIColor.white.cgColor
        self.collectionView.layer.borderWidth = 4
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
//                    self.arrayOfDefString.append(object["definition"].string!)
                    self.newVocab?.definitions.append(object["definition"].string!)
                    
                }
//                print("##############")
//                print(self.newVocab?.definitions)
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
        
        // set the definition for collection view
//        print("!!!!!!!!!!!!!!!")
//        print(self.newVocab?.definitions)
//        detailViewController.definitionOfWordArray = List<String>()
//        detailViewController.definitionOfWordArray?.append(self.newVocab?.definitions)
//        detailViewController.collectionView.reloadData()
        // go to detail page
        UIView.transition(from: self.mainView, to: self.containerView, duration: 1.2, options: [.transitionFlipFromLeft,.showHideTransitionViews]){
            (succed) in
            if succed {
                detailViewController.collectionView.reloadData()
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}



extension AddNewWordViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
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
        return cell
    }
    
    // select one cell and change the color of it
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let imageUrl = self.arrayOfPhotos![indexPath.row]["url_m"].string {
            let imageData = NSData(contentsOfFile: imageUrl)
            self.newVocab?.wordImage = imageData
        }
        
    }
 
}


