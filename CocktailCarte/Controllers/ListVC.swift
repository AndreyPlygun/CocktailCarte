//
//  ListVC.swift
//  CoctailDB
//
//  Created by Admin on 18.07.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ListVC: UITableViewController, UITabBarControllerDelegate, UISearchResultsUpdating {
    
    let appLogic = AppLogic()
    var searchController: UISearchController!
    var searchResults: [DrinkPreview]?
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "drinkCell")
        setupUI()
        appLogic.getDrinkList(from: category) { (drinks) in
            if DrinkPreview.drinks[self.category] == nil {
                DrinkPreview.drinks[self.category] = drinks
                DrinkPreview.approveFavorites(with: self.category)
            }
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchResults?.count ?? 0 : DrinkPreview.drinks[category]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath) as! TableViewCell
        cell.drink = searchController.isActive ? searchResults?[indexPath.row] : DrinkPreview.drinks[category]?[indexPath.row]
        return cell
    }
       
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "listToDetails", sender: DrinkPreview.drinks[category]?[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToDetails" {
            if let dvc = segue.destination as? DetailVC,
                let indexPath = tableView.indexPathForSelectedRow {
                dvc.drink = searchController.isActive ? searchResults?[indexPath.row] : DrinkPreview.drinks[category]?[indexPath.row]
            }
        }
        searchController.isActive = false
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            searchResults = DrinkPreview.drinks[category]!.filter({ (drink) -> Bool in
                return drink.name.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        }
    }
    
    func setupUI() {
        setupSearchBarUI()
        tabBarController?.delegate = self
        title = category
        tableView.rowHeight = 110
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
    }
    
    func setupSearchBarUI() {
        searchController = UISearchController(searchResultsController: nil)
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.view.tintColor = .black
        let sbar = searchController.searchBar
        sbar.barTintColor = .black
        sbar.layer.borderColor = UIColor.black.cgColor
        sbar.layer.borderWidth = 0.5
        sbar.clipsToBounds = true
        
        if let textField = sbar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(white: 0.15, alpha: 1)
            textField.textColor = .white
        }
    }
    
}
