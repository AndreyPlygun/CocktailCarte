//
//  CategoriesVC.swift
//  CoctailDB
//
//  Created by Admin on 21/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class CategoriesVC: UICollectionViewController {
    
    var categories: [String] = []
    var appLogic = AppLogic()
    var selectedItem: String?
    var shouldNotShowAbout = UserDefaults.standard.bool(forKey: "dontShowAgain")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        appLogic.getCategoriesList { [weak self] (result) in
            self?.categories = result ?? []
            self?.collectionView.reloadData()            
        }
    }
    
    func setupUI() {
        let nibCell = UINib(nibName: "CategoryCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "cCell")
        collectionView.setCollectionViewLayout(CollectionLayout(), animated: false)
        title = "Categories"
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.tintColor = .white
        navBar?.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "About", style: .plain, target: self, action: #selector(showAbout))
    }
    
    @objc private func showAbout() {
        let aboutVC = Storyboard.about.controller(withClass: AboutVC.self)!
        aboutVC.modalPresentationStyle = .popover
        present(aboutVC, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !shouldNotShowAbout {
            showAbout()
            shouldNotShowAbout = true
        }
    }
    
    // MARK: - CollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cCell", for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        cell.customInit(category: categories[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = categories[indexPath.row]
        performSegue(withIdentifier: "showList", sender: selectedItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showList", let dvc = segue.destination as? ListVC {
            dvc.category = selectedItem!
        }
    }
}
