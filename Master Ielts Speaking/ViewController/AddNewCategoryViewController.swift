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

/**
 * screen to add the new category
 *
 * - author: Amir
 *
 */
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
    @IBOutlet weak var noInternetView: UIView!
    
    @IBOutlet weak var pexelView: PexelView!
    // properties
    var arrayOfPhotos : [JSON]? = nil
//    var arrayOfDefString = [String]()
    var newCategory : Category? = nil
    var category : Category? = nil
    var imageSelected : UIImage? = nil
    var hasDefinition = true
    weak var delegate : ReloadViewDelegate?
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = UIColor.red
        return activityIndicator
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pexelView.delegate = self
        self.noInternetView.isHidden = true
        checkConectivity()
        // Configure the text view to make it's corner radiuos
        self.textViewBackGround.layer.cornerRadius = 8
        self.textViewBackGround.layer.masksToBounds = true
        self.newWord.layer.cornerRadius = 8
        // Make the add button circle
        self.addNewWordButton.layer.cornerRadius = 7
        // configure distances between cells
        self.collectionView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 3)
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// check connectivity to Internet
    fileprivate func checkConectivity() {
        guard Connectivity.isConnectedToInternet else {
            print("No! internet is not available.")
            self.noInternetView.isHidden = false
            return
        }
    }
    // Add new category 
    fileprivate func getPhotoForCategoryByName() {
        // search for photos related to the new word
        PexelsService.getPhotosPexels(searchKey: (self.newCategory?.categoryName)!) { [weak self] (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("=============")
                print(json)
                print("ffff")
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.arrayOfPhotos = json["photos"].array
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                self?.showAlert("ohhhh No!", "There is no Photo for this word")
                print(error.localizedDescription)
            }
        }
//        FlickrService.getPhotos(searchKey: (self.newCategory?.categoryName)!) {[weak self] (response) in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                DispatchQueue.main.async {
//                    self?.activityIndicator.stopAnimating()
//                    self?.arrayOfPhotos = json["photos"]["photo"].array
//                    self?.collectionView.reloadData()
//                }
//            case .failure(let error):
//                self?.showAlert("ohhhh No!", "There is no Photo for this word")
//                print(error.localizedDescription)
//            }
//        }
    }
    
    @IBAction func addNewCategoryButton(_ sender: UIButton) {
        self.view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        // make the titleOfCollection unhidden
        self.titleOfCollection.isHidden = false
        self.pexelView.isHidden = false
        // give the nameofWord property to it
        guard let newWordString = self.newWord.text else { return  }
        if newWordString == "" {
            showAlert("Enter a word", "Please enter a word")
            return}
        checkRepeatofCategories(category: newWordString) {[weak self] (status) in
            guard !status else {
                self?.newWord.text = ""
                self?.activityIndicator.stopAnimating()
                self?.showAlert("The \(newWordString) is repetitive", "Choose another object", completion: {
                })
                return
            }
            // create word object
            newCategory = Category()
            newCategory?.categoryName = newWordString
            getPhotoForCategoryByName()
        }
        
 
        /*
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
        */
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

/// Extend to implement collection view
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
        if let imageUrl = self.arrayOfPhotos![indexPath.row]["src"]["medium"].string {
//        if let imageUrl = self.arrayOfPhotos![indexPath.row]["media"].string
//        {
        
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

