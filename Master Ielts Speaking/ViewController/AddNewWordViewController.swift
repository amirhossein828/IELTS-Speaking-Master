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

/// It will avoid reloading photos during scrolling
var imageCacheNew = NSCache<AnyObject, UIImage>()


/**
 * screen to add the new word to specific category
 *
 * - author: Amir
 *
 */
class AddNewWordViewController: UIViewController {
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var newWord: UITextView!
    @IBOutlet weak var textViewBackGround: UIView!
    @IBOutlet weak var addNewWordButton: UIButton!
    @IBOutlet weak var dismissScreen: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleOfCollection: UILabel!
    @IBOutlet weak var noInternetView: UIView!
    
    @IBOutlet weak var pexelView: PexelView!
    
    // properties
    var arrayOfPhotos : [JSON]? = nil
    var arrayOfDefString = [String]()
    var newVocab : Word? = nil
    var category : Category? = nil
    var imageSelected : UIImage? = nil
    var hasDefinition = true
    weak var delegate : ReloadViewDelegate?
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = UIColor.green
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pexelView.delegate = self
        self.noInternetView.isHidden = true
        configureCloseButton()
        checkConectivity()
        self.view.addSubview(self.containerView)
        self.containerView.isHidden = true
        // Configure the text view to make it's corner radiuos
        self.textViewBackGround.layer.cornerRadius = 8
        self.textViewBackGround.layer.masksToBounds = true
        self.newWord.layer.cornerRadius = 8
        // Make the add button circle
        self.addNewWordButton.layer.cornerRadius = 7
        // configure distances between cells
        self.collectionView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 3)
        // color of the text inside next button grey when it is not selected
        self.nextButton.setTitleColor(UIColor.gray, for: .disabled)
        self.hideKeyboardWhenTappedAround()
    }
    
    ///close Screen
    @IBAction func dismissScreen(_ sender: UIButton) {
        self.delegate?.reloadTableViewByNewData()
        dismissThePage()
    }
    
    /// configure close button
    fileprivate func configureCloseButton() {
        let closeImageButton = UIImage(named: "close")!.withRenderingMode(.alwaysTemplate)
        self.dismissScreen.setImage(closeImageButton, for: .normal)
        self.dismissScreen.imageView?.tintColor = UIColor.white
    }
    
    /// check connectivity to Internet
    fileprivate func checkConectivity() {
        guard Connectivity.isConnectedToInternet else {
            print("No! internet is not available.")
            self.noInternetView.isHidden = false
            return
        }
    }
    // Get definitions and example of words and photos related to this word
    fileprivate func getPhotosAndDefFor(_ newWordString: String) {
        getDefinitionsAndPhotos(withWord: newWordString, viewController: self, arrayOfDefObject: {[weak self] (arrayOfDefObjects) in
            for object in arrayOfDefObjects {
                self?.newVocab?.definitions.append(object["definition"].string!)
            }
            // search for photos related to the new word
            PexelsService.getPhotosPexels(searchKey: (self?.newVocab?.wordName)!) { [weak self] (response) in
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
//            FlickrService.getPhotos(searchKey: (self?.newVocab?.wordName)!) { (response) in
//                switch response.result {
//                case .success(let value):
//                    let json = JSON(value)
//                    DispatchQueue.main.async {
//                        self?.activityIndicator.stopAnimating()
//                        self?.arrayOfPhotos = json["photos"]["photo"].array
//                        self?.collectionView.reloadData()
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
            }, arrayOfExampleObject: {[weak self] (arrayOfExampObjects) in
                for object in arrayOfExampObjects {
                    self?.newVocab?.examples.append(object.string!)
                }
        }) { (massage) in
            //                self.showAlert("ohhhhhh No!", massage)
        }
    }
    
    @IBAction func addNewWordButton(_ sender: UIButton) {
        self.view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        // make next button unable till user choose one photo
        self.nextButton.isEnabled = false
        // make titleOfCollection label unhidden
        self.titleOfCollection.isHidden = false
        self.pexelView.isHidden = false
        // create word object
        newVocab = Word()
        // give the nameofWord property to it
        guard let newWordString = self.newWord.text else { return  }
        if newWordString == "" {
            showAlert("Enter a word", "Please enter a word")
            return}
        checkRepeatofWords(word: newWordString) {[weak self] (status) in
            guard !status else {
                self?.newWord.text = ""
                self?.activityIndicator.stopAnimating()
                self?.showAlert("The \(newWordString) is repetitive", "Choose another object", completion: {
                })
                return
            }
            newVocab?.wordName = newWordString
            getPhotosAndDefFor(newWordString)
        }
    }

    // come back to list of categories
    func dismissThePage() {
        self.dismiss(animated: true, completion: nil)
    }
    // Go to detail view controller
    @IBAction func nextButton(_ sender: UIButton) {
        // save in database
        saveData(newVocab!)
        updateCategoryInDatabase(categoryName: (self.category?.categoryName)!, word: newVocab!)
        print(self.childViewControllers[0])
        let detailViewController = self.childViewControllers[0] as! DetailViewController
        detailViewController.newVocabulary = self.newVocab
        detailViewController.topView.text = detailViewController.newVocabulary?.wordName
        detailViewController.isComeFromInfo = false
        // go to detail page
        UIView.transition(from: self.mainView, to: self.containerView, duration: 1.2, options: [.transitionFlipFromLeft,.showHideTransitionViews]){
            (succed) in
            if succed {
                // configure the detail viewcontroller when transition get completed
                detailViewController.examplePageControl.numberOfPages = (self.newVocab?.examples.count)! < 14 ? (self.newVocab?.examples.count)! : 14
                detailViewController.pageControl.numberOfPages = (self.newVocab?.definitions.count)! < 14 ? (self.newVocab?.definitions.count)! : 14
                detailViewController.collectionView.reloadData()
                detailViewController.advCollectionView.reloadData()
                detailViewController.exampleCollectionView.reloadData()
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // Lock orientation
    override open var shouldAutorotate: Bool {
        return false
    }
}


/// Extend to implement collection view
extension AddNewWordViewController : UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
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
            cell.imageView.downloadedFrom(link: imageUrl, completion: {
                cell.activityIndicator.stopAnimating()
            })
//            cell.imageView.downloadedFrom(link: imageUrl)
        }
        cell.imageView.layer.cornerRadius = 7
        return cell
    }
    
    // select one cell and change the color of it
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoCell = self.collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        let imageCell = photoCell.imageView.image
        self.newVocab?.wordImage = UIImageJPEGRepresentation(imageCell!, 0.4)
        self.nextButton.isEnabled = true
        
    }
    
    // make the size of each cell half of the screen
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


