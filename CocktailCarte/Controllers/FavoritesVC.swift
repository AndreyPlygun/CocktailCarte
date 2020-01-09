//
//  FavoriteVC.swift
//  CoctailDB
//
//  Created by Admin on 18.07.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritesVC: UITableViewController, UITabBarControllerDelegate {
    
    var realm: Realm?

    override func viewDidLoad() {
        realm = try! Realm()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "drinkCell")
        tabBarController?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable(notification:)), name: .updateFavorites, object: nil)
        setupUI()
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm?.objects(DrinkShort.self).count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath) as! TableViewCell
        cell.drink = DrinkPreview(realmObject: (realm?.objects(DrinkShort.self)[indexPath.row])!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "favToDetails", sender: realm?.objects(DrinkShort.self)[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favToDetails" {
            if let dvc = segue.destination as? DetailVC,
                let indexPath = tableView.indexPathForSelectedRow {
                dvc.drink = DrinkPreview(realmObject: (realm?.objects(DrinkShort.self)[indexPath.row])!)
            }
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc func updateTable(notification: NSNotification) {
        tableView.reloadData()
    }
    
    func setupUI() {
        tableView.rowHeight = 110
        title = "Favorites"
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.tintColor = .white
        navBar?.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
    }
    
}

extension Notification.Name {
    static let updateFavorites = Notification.Name("updateFavorites")
}
