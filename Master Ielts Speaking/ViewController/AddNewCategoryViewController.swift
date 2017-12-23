//
//  AddNewCategoryViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-15.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

class AddNewCategoryViewController: UIViewController {
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var newWord: UITextView!
    @IBOutlet weak var textViewBackGround: UIView!
    @IBOutlet weak var addNewWordButton: UIButton!
    @IBOutlet weak var dismissScreen: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleOfCollection: UILabel!
    // properties
    var arrayOfPhotos : [JSON]? = nil
//    var arrayOfDefString = [String]()
    var newCategory : Category? = nil
    var category : Category? = nil
    var imageSelected : UIImage? = nil
    var hasDefinition = true
    weak var delegate : ReloadViewDelegate?
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the text view to make it's corner radiuos
        self.textViewBackGround.layer.cornerRadius = 8
        self.textViewBackGround.layer.masksToBounds = true
        self.newWord.layer.cornerRadius = 8
        // configure close button
        let closeImageButton = UIImage(named: "close")!.withRenderingMode(.alwaysTemplate)
        self.dismissScreen.setImage(closeImageButton, for: .normal)
        self.dismissScreen.imageView?.tintColor = UIColor.white
        // Make the add button circle
        self.addNewWordButton.layer.cornerRadius = 7
        // configure distances between cells
        self.collectionView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 3)
        // color of the text inside next button grey when it is not selected
        // configure close button
        let addImageButton = UIImage(named: "add")!.withRenderingMode(.alwaysTemplate)
        self.doneButton.setImage(addImageButton, for: .normal)
        self.doneButton.imageView?.tintColor = UIColor.white
        self.doneButton.setTitleColor(UIColor.gray, for: .disabled)
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addNewCategoryButton(_ sender: UIButton) {
        // make the titleOfCollection unhidden
        self.titleOfCollection.isHidden = false
        // create word object
        newCategory = Category()
        // give the nameofWord property to it
        guard let newWordString = self.newWord.text else { return  }
        if newWordString == "" {
            showAlert("Enter a word", "Please enter a word")
            return}
        newCategory?.categoryName = newWordString
        // search for photos related to the new word
        /*
        FlickrService.getPhotos(searchKey: (self.newCategory?.categoryName)!) { (response) in
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
 */
        QwantApiService.getPhotos(searchKey: (self.newCategory?.categoryName)!) { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                DispatchQueue.main.async {
                    let arrayOfPhotosObjects = json["data"]["result"]["items"].array
                    self.arrayOfPhotos = [JSON]()
                    for object in arrayOfPhotosObjects! {
                        self.arrayOfPhotos?.append(object)
                    }
                    print(self.arrayOfPhotos!)
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
      }
        
    
    
    // come back to list of categories
    func dismissThePage() {
        delegate?.reloadTableViewByNewData()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        // check if a category name got chosen
        if self.newWord.text == ""  {
            showAlert("Enter a Category", "Please Enter a Category Name")
            return
        }
        // check if a photo got chosen for the category.
        if self.newCategory?.categoryImageData == nil {
            showAlert("Choose an Image", "Please Choose an Image for Category")
            return
        }
        // save in database
        saveData(newCategory!)
        dismissThePage()
        
    }

    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    

}

extension AddNewCategoryViewController : UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayOfPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PhotoCollectionViewCell
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.hidesWhenStopped = true
//        if let imageUrl = self.arrayOfPhotos![indexPath.row]["url_m"].string {
        if let imageUrl = self.arrayOfPhotos![indexPath.row]["media"].string
        {
            
            print(imageUrl)
            cell.imageView.downloadedFrom(link: imageUrl, completion: {
                cell.activityIndicator.stopAnimating()
            })
        }
        return cell
    }
    
    // select one cell and change the color of it
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoCell = self.collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        let imageCell = photoCell.imageView.image
        self.newCategory?.categoryImageData = UIImageJPEGRepresentation(imageCell!, 0.4)
        self.doneButton.isEnabled = true
        
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

