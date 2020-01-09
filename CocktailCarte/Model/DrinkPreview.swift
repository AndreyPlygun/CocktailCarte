//
//  DrinkShortInfo.swift
//  CoctailDB
//
//  Created by Admin on 22.07.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class DrinkPreview: Equatable {
    static func == (lhs: DrinkPreview, rhs: DrinkPreview) -> Bool {
        return lhs.id == rhs.id
    }
    
    static var drinks: [String : [DrinkPreview]] = [:] // K - category of drinks, V - drinks
    static var tempDrink: DrinkShort?
    
    var id: String
    var name: String
    var imageURL: String
    var isLiked = false
    var category: String
    var image: NSData?
    
    private struct APIKeys {
        static let idDrink = "idDrink"
        static let strDrink = "strDrink"
        static let strDrinkThumb = "strDrinkThumb"
    }
    
    init?(dictionary: [String : Any], category: String?) {
        guard let idDrink = dictionary[APIKeys.idDrink] as? String,
            let strDrink = dictionary[APIKeys.strDrink] as? String,
            let strDrinkThumbString = dictionary[APIKeys.strDrinkThumb] as? String else {
                return nil
        }
        
        self.id = idDrink
        self.name = strDrink
        self.imageURL = strDrinkThumbString
        self.category = category ?? ""
    }
    
    init(realmObject: DrinkShort) {
        self.id = realmObject.id
        self.imageURL = realmObject.imageURL
        self.name = realmObject.name
        self.isLiked = realmObject.isLiked
        self.category = realmObject.category        
    }
    
    /**
     Approves downloaded list of drink in given category to be matched list of favorite drinks stored in Realm
     - parameter category: name of category for approving
    */
    static func approveFavorites(with category: String) {
        let objects = try! Realm().objects(DrinkShort.self).filter("category = '\(category)'")
        drinks[category]?.forEach({ (drink) in
            drink.isLiked = objects.filter("id = '\(drink.id)'").first?.isLiked ?? false
        })
    }
    
}

extension Array where Element: Equatable {
    func index(of element: Element) -> Int {
        for i in 0...self.count - 1 {
            if element == self[i] {
                return i
            }
        }
        return -1
    }
    
    func contains(_ element: Element) -> Bool {
        if index(of: element) != -1 {
            return true
        }
        return false
    }
}
