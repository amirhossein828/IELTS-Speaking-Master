//
//  InfoCollectionViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-08.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

// protocol which declare method to delegate reloading table view when coming back from addCategoryViewController
protocol ReloadViewDelegate : class{
    func reloadTableViewByNewData()
}

class InfoCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UIScrollViewDelegate {
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addWordButton: UIButton!
    @IBOutlet weak var cancelDeleting: UIBarButtonItem!
    // Properties
    var arrayOfWords = List<Word>()
    var categoryFrom : Category? = nil
    let transition = AnimationTransition()
    var deleteButtenIsHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addWordButton.layer.cornerRadius = (addWordButton.frame.size.width) / 2
        let addButtonImage = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        addWordButton.setImage(addButtonImage, for: .normal)
        addWordButton.imageView?.tintColor = UIColor.white
        for word in (self.categoryFrom?.words)! {
            self.arrayOfWords.append(word)
        }
        collectionView?.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 1, right: 5)
        self.navigationItem.title = self.categoryFrom?.categoryName
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? CustomLayout {
            layout.delegate = self
        }
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Lock orientation
    override open var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        self.deleteButtenIsHidden = false
        self.cancelDeleting.isEnabled = true
        self.collectionView.reloadData()
    }
    
    @IBAction func addNewWordButton(_ sender: UIButton) {
        
        let customLayout =  collectionView.collectionViewLayout as! CustomLayout
        customLayout.cache.removeAll()
        self.performSegue(withIdentifier: "goAddNewWord", sender: self)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayOfWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EachCategoryCollectionViewCell
        cell.delegate = self
        cell.setCell(withWord: self.arrayOfWords[indexPath.row], withIndex : indexPath, shouldHidden : self.deleteButtenIsHidden)
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goAddNewWord" {
            let vc = segue.destination as! AddNewWordViewController
            vc.category = self.categoryFrom
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
            vc.delegate = self
        }
    }
    // Go to DetailViewController when user clicks
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.newVocabulary = self.arrayOfWords[indexPath.row]
        detailViewController.isComeFromInfo = true
        let numberOfDefinitions = self.arrayOfWords[indexPath.row].definitions.count
        detailViewController.pageControlDots = numberOfDefinitions < 14 ? numberOfDefinitions : 14
        let numberOfExamples = self.arrayOfWords[indexPath.row].examples.count
        detailViewController.pageControlExampleDots = numberOfExamples < 14 ? numberOfExamples : 14
        self.present(detailViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.deleteButtenIsHidden = true
        self.cancelDeleting.isEnabled = false
        self.collectionView.reloadData()
    }
    


}


//MARK: - CUSTOM LAYOUT DELEGATE
extension InfoCollectionViewController : CustomLayoutDelegate {
    
    //  Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        if let imageData = self.arrayOfWords[indexPath.item].wordImage {
            let height = (UIImage(data: imageData as Data)?.size.height)!
            if height > 220 &&  height < 800{
                return height/4
            }else if height > 800 {
                return height/8
            }else if height < 220{
                return 110
            }
            else {
                return height
            }
            
        }
        if let imageString = self.arrayOfWords[indexPath.item].wordImageString {
            let heightString = (UIImage(named: imageString)?.size.height)!
            if heightString > 220 &&  heightString < 800{
                return heightString/4
            }else if heightString > 800 {
                return heightString/8
            }else if heightString < 220{
                 return 110
            }
            else {
                return heightString
            }
        }
        return 0
    }
    
}

extension InfoCollectionViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition.transitionMode = .present
        self.transition.startingPoint = self.addWordButton.center
        return self.transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition.transitionMode = .dismiss
        self.transition.startingPoint = self.addWordButton.center
        return self.transition
    }
  
    
}

extension InfoCollectionViewController : ReloadViewDelegate {
    func reloadTableViewByNewData() {
        self.arrayOfWords.removeAll()
        for word in (self.categoryFrom?.words)! {
            self.arrayOfWords.append(word)
            self.collectionView.reloadData()
        }
    }
}

// extention to adopt to DeleteCellDelegate and remove cell selected by user from database and array
extension InfoCollectionViewController : DeleteCellDelegate {
    func deleteCell(withIndex: IndexPath) {
        let customLayout =  collectionView.collectionViewLayout as! CustomLayout
        customLayout.cache.removeAll()
        deleteFromDatadase((self.categoryFrom?.words[withIndex.row])!)
        self.arrayOfWords.remove(at: withIndex.row)
        self.collectionView.reloadData()
    }
   
}


