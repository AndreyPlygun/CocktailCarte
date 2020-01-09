//
//  DetailVC.swift
//  CoctailDB
//
//  Created by Admin on 18.07.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import RealmSwift

class DetailVC: UIViewController {
    
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var drink: DrinkPreview!
    var drinkReceipe: DrinkReceipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppLogic().downloadDrinkReceipe(by: drink.id) { (drinkReceipe) in
            self.drinkReceipe = drinkReceipe
            self.updateUI()
        }
    }
    
    func updateUI() {
        let realm = try! Realm()
        drinkName.text = drink.name
        if let url = URL(string: drink.imageURL) {
            drinkImageView.sd_setImage(with: url, completed: nil)
            drinkImageView.layer.cornerRadius = 10
            drinkImageView.layer.masksToBounds = true
        }
        let savedDrink = realm.objects(DrinkShort.self).filter("id = '\(drink.id)'").first
        ingredientsTextView.text = drinkReceipe?.ingredients ?? savedDrink!.ingredients
        instructionsTextView.text = "\(drinkReceipe?.strInstructions ?? savedDrink!.instructions)\nServe: \(drinkReceipe?.strGlass ?? savedDrink!.glass)"
        updateFavoriteButtonUI(drink.isLiked)
    }
    
    @IBAction func mark(_ sender: UIButton) {
        AppLogic().addToFavorite(drink: drink)
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
