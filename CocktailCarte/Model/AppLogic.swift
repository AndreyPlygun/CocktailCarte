//
//  AppLogic.swift
//  CoctailDB
//
//  Created by Admin on 19.07.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

struct AppLogic {
    /**
     Downloads list of drinks from given category
     - parameter category: name of category
     - parameter completion: closure to be executed after downloading drinks
     */
    func getDrinkList(from category: String, completion: @escaping ([DrinkPreview]?) -> Void) {
        var drinks = [DrinkPreview]()
        let URLRequest = ServerEndpoint.filterByCategory(category: category).request
        Alamofire.request(URLRequest).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any],
                let drinkDictionaries = json["drinks"] as? [[String : Any]] else {
                    completion(nil)
                    return
            }
            for dict in drinkDictionaries {
                drinks.append(DrinkPreview(dictionary: dict, category: category)!)
            }
            completion(drinks)
        }
    }
    
    /**
     Downloads list of categories
     - parameter completion: closure to be executed after downloading list
     */
    func getCategoriesList(completion: @escaping ([String]?) -> Void) {
        let categoriesRequest = ServerEndpoint.listCategoriesFilters.request
        var result: [String] = []
        Alamofire.request(categoriesRequest).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any],
                let dictionaries = json["drinks"] as? [[String : Any]] else {
                    completion(nil)
                    return
            }
            for dict in dictionaries {
                result.append((dict.values.first! as? String)!)
            }
            completion(result)
        }
    }
    
    /**
     Gets list of drinks that satisfy given name
     - parameter name: name to be used for searching
     - parameter completion: closure to be executed after downloading list of drinks
     */
//    func searchCocktail(name: String, completion: @escaping ([DrinkPreview]?) -> Void) {
//        let request = ServerEndpoint.searchCocktailByName(term: name).request
//        var drinks: [DrinkPreview] = []
//        Alamofire.request(request).responseJSON { (response) in
//            guard let json = response.result.value as? [String : Any],
//                let drinksDictionaries = json["drinks"] as? [[String : Any]] else {
//                    completion(nil)
//                    return
//            }
//            for dict in drinksDictionaries {
//                drinks.append(DrinkPreview(dictionary: dict, category: nil)!)
//            }
//            completion(drinks)
//        }
//    }
    
    /**
     Downloads full receipe of drink by given drink's id
     - parameter id: id of drink
     - parameter completion: closure to be executed after downloading receipe of drink
    */
    func downloadDrinkReceipe(by id: String, completion: @escaping (DrinkReceipe?) -> Void) {
        let URLRequest = ServerEndpoint.lookupDrinkDetails(id: id).request
        Alamofire.request(URLRequest).responseJSON { (response) in
            do {
                let data = try JSONDecoder().decode(Drinks.self, from: response.data!)
                completion(data.drinks.first)
            } catch {
                completion(nil)
            }
        }
    }
    
    /**
     Adds to Realm (if not liked) or removes from Realm (if alredy liked) given drink
     - parameter drink: given drink to be added or removed
    */
    func addToFavorite(drink: DrinkPreview) {
        let realm = try! Realm()
        try! realm.write {
            if drink.isLiked {
                drink.isLiked = false
                let tempDrink = realm.objects(DrinkShort.self).filter("id = '\(drink.id)'").first!
                DrinkPreview.tempDrink = DrinkShort(value: [tempDrink.id, tempDrink.name, tempDrink.imageURL, tempDrink.isLiked, tempDrink.category, tempDrink.ingredients, tempDrink.instructions, tempDrink.glass])
                realm.delete(realm.objects(DrinkShort.self).filter("id = '\(drink.id)'").first!)
                DrinkPreview.approveFavorites(with: drink.category)
            } else {
                drink.isLiked = true
                AppLogic().downloadDrinkReceipe(by: drink.id, completion: { (receipe) in
                    try! realm.write {
                        realm.add(DrinkShort(value: [drink.id, drink.name, drink.imageURL, drink.isLiked, drink.category, receipe?.ingredients ?? DrinkPreview.tempDrink!.ingredients, receipe?.strInstructions ?? DrinkPreview.tempDrink!.instructions, receipe?.strGlass ?? DrinkPreview.tempDrink!.glass]))
                    }
                    DrinkPreview.approveFavorites(with: drink.category)
                })
                
            }
        }
    }
    
}
