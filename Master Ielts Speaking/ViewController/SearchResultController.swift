//
//  SearchResultController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-20.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit
import  RealmSwift

class SearchResultController: UITableViewController , UISearchResultsUpdating, UISearchBarDelegate{
    // list of categories
    var categoryList : [Category]? = {
        var resultArray = [Category]()
        readData(Category.self, predicate: nil, completion: { (response : Results<Category>) in
            for category in response {
                resultArray.append(category)
            }
            
        })
        return resultArray
    }()
    // list of words
    var wordList : [Word]? = {
        var resultArray = [Word]()
        readData(Word.self, predicate: nil, completion: { (response : Results<Word>) in
            for word in response {
                resultArray.append(word)
            }
            
        })
        return resultArray
    }()
    
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // this is a function get called, whenever user type text
    func updateSearchResults(for searchController: UISearchController) {
        
        
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
            if isCategory == true {
                return categoryList?.count ?? 0
            }else{
                return wordList?.count ?? 0
            }
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        if tableView == self.tableView {
            if isCategory == true {
                cell.textLabel?.text = self.categoryList![indexPath.row].categoryName
                return cell
            }else {
                cell.textLabel?.text = self.wordList![indexPath.row].wordName
                return cell
            }
        }else {
            return cell
        }
    }

}
