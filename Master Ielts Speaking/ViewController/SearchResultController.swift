//
//  SearchResultController.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-20.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import UIKit

class SearchResultController: UITableViewController , UISearchResultsUpdating{
    
    
    var searchController : UISearchController!
    var resultController = UITableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultController.tableView.dataSource = self
        self.resultController.tableView.delegate = self
        // whenever user type text in search bar it will replace the table view with new table view
        self.searchController = UISearchController(searchResultsController: self.resultController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.showsScopeBar = true
        self.searchController.searchBar.scopeButtonTitles = ["Category","Vocabulary"]
        self.searchController.searchResultsUpdater = self
        // avoid white wierd space
        definesPresentationContext = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // this is a function get called, whenever user type text
    func updateSearchResults(for searchController: UISearchController) {
        // filter through cars
        // go through each item of array and returns true
        /*
        self.filterCars =   self.cars.filter { (car: String) -> Bool in
            // check if one string is inside another string
            if car.lowercased().contains((self.searchController.searchBar.text?.lowercased())!){
                return true
            }else {
                return false
            }
            
        }
         */
        // update result from table view
        self.resultController.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    

}
