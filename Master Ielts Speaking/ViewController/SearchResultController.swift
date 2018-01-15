//
//  SearchResultController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-20.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import  RealmSwift

/**
 * Search screen
 *
 * - author: Amir
 *
 */
class SearchResultController: UITableViewController , UISearchResultsUpdating, UISearchBarDelegate{
    /// list of categories
    lazy var categoryList : [Category]? = {
        var resultArray = [Category]()
        readData(Category.self, predicate: nil, completion: { (response : Results<Category>) in
            for category in response {
                resultArray.append(category)
            }
        })
        return resultArray
    }()
    var filterCategoryList = [Category]()
    var category : Category? = nil
    /// list of words
    lazy var wordList : [Word]? = {
        var resultArray = [Word]()
        readData(Word.self, predicate: nil, completion: { (response : Results<Word>) in
            for word in response {
                resultArray.append(word)
            }
        })
        return resultArray
    }()
    var filterWordList = [Word]()
    var word : Word? = nil
    var searchController : UISearchController!
    var resultController = UITableViewController()
    var isCategory = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultController.tableView.dataSource = self
        self.resultController.tableView.delegate = self
        // whenever user type text in search bar it will replace the table view with new table view
        self.searchController = UISearchController(searchResultsController: self.resultController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.showsScopeBar = true
        self.searchController.searchBar.scopeButtonTitles = ["Category","Vocabulary"]
        self.searchController.searchBar.selectedScopeButtonIndex = 0
        self.searchController.searchResultsUpdater = self
        // avoid white wierd space
        definesPresentationContext = true
        self.searchController.searchBar.delegate = self
        self.resultController.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Lock orientation
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
    // this is a function get called, whenever user type text
    func updateSearchResults(for searchController: UISearchController) {
        if isCategory {
            // filter through categories
            // go through each item of array and returns true
            self.filterCategoryList =   (self.categoryList?.filter { (category : Category) -> Bool in
                // check if one string is inside another string
                if category.categoryName.lowercased().contains((self.searchController.searchBar.text?.lowercased())!){
                    return true
                }else {
                    return false
                }
                })!
            // update result from table view
            self.resultController.tableView.reloadData()
        }else {
            // filter through categories
            // go through each item of array and returns true
            self.filterWordList =   (self.wordList?.filter { (word : Word) -> Bool in
                // check if one string is inside another string
                if word.wordName.lowercased().contains((self.searchController.searchBar.text?.lowercased())!){
                    return true
                }else {
                    return false
                }
                
                })!
            // update result from table view
            self.resultController.tableView.reloadData()
        }
        
    }
    // this is a function get called, whenever the scope button selection changed
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0 {
            isCategory = true
            tableView.reloadData()
        }else{
            isCategory = false
            tableView.reloadData()
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            if isCategory  {
                return categoryList?.count ?? 0
            }else{
                return wordList?.count ?? 0
            }
        }else {
            if isCategory  {
                return filterCategoryList.count
            }else{
                return filterWordList.count
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        if tableView == self.tableView {
            if isCategory  {
                cell.textLabel?.text = self.categoryList![indexPath.row].categoryName
                return cell
            }else {
                cell.textLabel?.text = self.wordList![indexPath.row].wordName
                return cell
            }
        }else {
            if isCategory {
                cell.textLabel?.text = self.filterCategoryList[indexPath.row].categoryName
                return cell
            }else {
                cell.textLabel?.text = self.filterWordList[indexPath.row].wordName
                return cell
            }
        }
    }
    
    // It detect which row get selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            showDetail(withCategoryArray: self.categoryList!, withWordArray: self.wordList!, withIndexPath: indexPath.row)
        }else {
            showDetail(withCategoryArray: self.filterCategoryList, withWordArray: self.filterWordList, withIndexPath: indexPath.row)
        }
  
    }
    
    // Based on is it a list of categories or words and or which array is used it will go to InfoCollectionViewController or DetailViewController
    private func showDetail( withCategoryArray :[Category], withWordArray : [Word] ,withIndexPath : Int ) {
        if self.isCategory {
            self.category = withCategoryArray[withIndexPath]
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let infoVC = sb.instantiateViewController(withIdentifier: "InfoCollectionViewController") as! InfoCollectionViewController
            infoVC.categoryFrom = self.category
            show(infoVC, sender: self)
        }else {
            self.word = withWordArray[withIndexPath]
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailVC.newVocabulary = self.word
            detailVC.isComeFromSearch = true
            show(detailVC, sender: self)
        }
    }

}
