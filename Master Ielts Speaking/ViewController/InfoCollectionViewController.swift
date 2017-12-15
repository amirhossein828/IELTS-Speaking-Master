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

class InfoCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrayOfWords = List<Word>()
    var categoryFrom : Category? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for word in (self.categoryFrom?.words)! {
            self.arrayOfWords.append(word)
        }
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        self.navigationItem.title = self.categoryFrom?.categoryName
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? CustomLayout {
            layout.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.arrayOfWords.removeAll()
        
        for word in (self.categoryFrom?.words)! {
            self.arrayOfWords.append(word)
            self.collectionView.reloadData()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.setCell(withWord: self.arrayOfWords[indexPath.row])
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
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.newVocabulary = self.arrayOfWords[indexPath.row]
        detailViewController.isComeFromInfo = true
        detailViewController.pageControlDots = self.arrayOfWords[indexPath.row].definitions.count
        self.present(detailViewController, animated: true, completion: nil)
    }
    
    

}


//MARK: - CUSTOM LAYOUT DELEGATE
extension InfoCollectionViewController : CustomLayoutDelegate {
    
    //  Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        if let imageData = self.arrayOfWords[indexPath.item].wordImage {
            let height = (UIImage(data: imageData as Data)?.size.height)!
            if height > 450 {
                return 450
            }else {
                return height
            }
            
        }
        if let imageString = self.arrayOfWords[indexPath.item].wordImageString {
            let heightString = (UIImage(named: imageString)?.size.height)!
            if heightString > 450 {
                return 450
            }else {
                return heightString
            }
        }
        return 0
    }
    
}
