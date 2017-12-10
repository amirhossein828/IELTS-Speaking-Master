//
//  AddNewWordViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-09.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit

class AddNewWordViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var newWord: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.containerView)
        self.containerView.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    func dismissThePage() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func nextButton(_ sender: UIButton) {
        UIView.transition(from: self.mainView, to: self.containerView, duration: 1.2, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

extension AddNewWordViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = UIColor.red
        
        return cell
    }
    
    
    
    
    
    
}
