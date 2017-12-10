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

    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var definitionOfWordArray : List<String>? = nil
    var newVocabulary : Word? = nil
    
    lazy var vc : AddNewWordViewController = {
        return self.parent as! AddNewWordViewController
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    


    @IBAction func backButton(_ sender: UIButton) {
        vc.dismissThePage()
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
        return self.newVocabulary?.definitions.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellOfDef", for: indexPath) as! DefinitionCollectionViewCell
        if let arrayOfDefenition = self.newVocabulary?.definitions {
        cell.definitionFieldCell.text = arrayOfDefenition[indexPath.row]
        }
        cell.backgroundColor = UIColor.blue
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    
    
    

}
