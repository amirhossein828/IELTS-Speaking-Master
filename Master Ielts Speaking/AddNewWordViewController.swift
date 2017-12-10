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

// It will avoid reloading photos during scrolling
var imageCacheNew = NSCache<AnyObject, UIImage>()

class AddNewWordViewController: UIViewController {
    // Outkets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var newWord: UITextView!
    // properties
    var arrayOfPhotos : [JSON]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.containerView)
        self.containerView.isHidden = true
        self.collectionView.layer.borderColor = UIColor.white.cgColor
        self.collectionView.layer.borderWidth = 4
    }
    
    @IBAction func addNewWordButton(_ sender: UIButton) {
        // create word object
        let newWord = Word()
        // give the nameofWord property to it
        newWord.wordName = self.newWord.text
        // search for photos related to the new word
        FlickrService.getPhotos(searchKey: newWord.wordName) { (response) in
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
        UIView.transition(from: self.mainView, to: self.containerView, duration: 1.2, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
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
 
}


