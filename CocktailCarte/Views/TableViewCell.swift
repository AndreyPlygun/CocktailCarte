//
//  TableViewCell.swift
//  CoctailDB
//
//  Created by Admin on 25.07.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class TableViewCell: UITableViewCell {

    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var view: UIView!
    
    var drink: DrinkPreview! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        nameLabel.text = drink.name
        if let url = URL(string: drink.imageURL) {
            drinkImageView.sd_setImage(with: url, completed: nil)
        }
        self.drinkImageView.layer.cornerRadius = 10
        self.drinkImageView.layer.masksToBounds = true
        updateFavoriteButtonUI(drink.isLiked)
        self.view.layer.cornerRadius = 10
        self.view.layer.masksToBounds = true
    }
    
    @IBAction func mark(_ sender: UIButton) {
        AppLogic().addToFavorite(drink: drink)
        NotificationCenter.default.post(name: .updateFavorites, object: nil)
        updateFavoriteButtonUI(drink.isLiked)
    }
    
    func updateFavoriteButtonUI(_ isLiked: Bool) {
        if isLiked {
            favoriteButton.setImage(UIImage(named: "liked"), for: .normal)
            favoriteButton.alpha = 1
        } else {
            favoriteButton.setImage(UIImage(named: "notLiked"), for: .normal)
            favoriteButton.alpha = 0.1
        }
    }
    
}
