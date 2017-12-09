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
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savePhtosInDatabase()
       
        // read data
        readData(Category.self, predicate: nil) { (response : Results<Category>) in
            print(response)
            self.arrayOfCategories = response
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // read data
        readData(Category.self, predicate: nil) { (response : Results<Category>) in
            print(response)
            self.arrayOfCategories = response
        }
        self.tableView.reloadData()
    }
    
    func savePhtosInDatabase() {
        // create all category
        for count in 0..<2 {
            let category = Category()
            category.categoryId = String(count)
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


}

