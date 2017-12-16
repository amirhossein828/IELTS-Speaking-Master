//
//  ViewController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-08.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var arrayOfCategories : Results<Category>?
    let nameOfCategoriesArray = ["Environment","Friends"]
    let nameOfImagesInAssets = ["envir","Friends"]
    var category : Category? = nil
    let transition = AnimationTransition()
    
    @IBOutlet weak var backGroundV: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCategoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCategoryButton.layer.cornerRadius = (addCategoryButton.frame.size.width) / 2
        let addButtonImage = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        addCategoryButton.setImage(addButtonImage, for: .normal)
        addCategoryButton.imageView?.tintColor = UIColor.white
        // read data
        readData(Category.self, predicate: nil) { (response : Results<Category>) in
            print(response)
            self.arrayOfCategories = response
        }
    }
    
    
    func savePhtosInDatabase() {
        // create all category
        for count in 0..<2 {
            let category = Category()
            category.categoryName = self.nameOfCategoriesArray[count]
            category.categoryImage = self.nameOfImagesInAssets[count]
            // save the in Realm
            saveData(category)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.arrayOfCategories?.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CategoryTableViewCell

        cell.categoryName.text = self.arrayOfCategories?[indexPath.row].categoryName ?? ""
        if let image = UIImage(named: (self.arrayOfCategories?[indexPath.row].categoryImage) ?? "") {
            cell.categoryImage.image = image
        }else if let imageFromUser = UIImage(data: (self.arrayOfCategories?[indexPath.row].categoryImageData)! as Data) {
            cell.categoryImage.image = imageFromUser
        } else {
            cell.categoryImage.image = #imageLiteral(resourceName: "Base")
        }
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.category = self.arrayOfCategories?[indexPath.row]
        self.performSegue(withIdentifier: "goDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFromDatadase(self.arrayOfCategories![indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetail" {
            let vc = segue.destination as! InfoCollectionViewController
            vc.categoryFrom = self.category
        }else {
            let addVC = segue.destination as! AddNewCategoryViewController
            addVC.transitioningDelegate = self
            addVC.modalPresentationStyle = .custom
            addVC.delegate = self
        }
    }

}

extension CategoryViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition.transitionMode = .present
        self.transition.startingPoint = self.addCategoryButton.center
//        self.transition.circleColor = self.addCategoryButton.backgroundColor!
        
        return self.transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition.transitionMode = .dismiss
        self.transition.startingPoint = self.addCategoryButton.center
//        self.transition.circleColor = self.addCategoryButton.backgroundColor!
        
        return self.transition
    }
  
}

extension CategoryViewController : ReloadViewDelegate {
    func reloadTableViewByNewData() {
        // read data
        readData(Category.self, predicate: nil) { (response : Results<Category>) in
            print(response)
            self.arrayOfCategories = response
        }
        self.tableView.reloadData()
    }
    
    
}

