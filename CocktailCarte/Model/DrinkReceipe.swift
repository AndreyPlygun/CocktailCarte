//
//  Drink.swift
//  CoctailDB
//
//  Created by Admin on 18.07.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

struct Drinks: Decodable {
    var drinks: [DrinkReceipe]
}

struct DrinkReceipe: Decodable {
    var idDrink: String?
    var strInstructions: String?
    var strIngredient1: String?
    var strIngredient2: String?
    var strIngredient3: String?
    var strIngredient4: String?
    var strIngredient5: String?
    var strIngredient6: String?
    var strIngredient7: String?
    var strIngredient8: String?
    var strIngredient9: String?
    var strIngredient10: String?
    var strIngredient11: String?
    var strIngredient12: String?
    var strIngredient13: String?
    var strIngredient14: String?
    var strIngredient15: String?
    var strMeasure1: String?
    var strMeasure2: String?
    var strMeasure3: String?
    var strMeasure4: String?
    var strMeasure5: String?
    var strMeasure6: String?
    var strMeasure7: String?
    var strMeasure8: String?
    var strMeasure9: String?
    var strMeasure10: String?
    var strMeasure11: String?
    var strMeasure12: String?
    var strMeasure13: String?
    var strMeasure14: String?
    var strMeasure15: String?
    var strGlass: String?
    
    var ingredients: String {
        return "\(strMeasure1 ?? "")\(strIngredient1 ?? "")\n\(strMeasure2 ?? "")\(strIngredient2 ?? "")\n\(strMeasure3 ?? "")\(strIngredient3 ?? "")\n\(strMeasure4 ?? "")\(strIngredient4 ?? "")\n\(strMeasure5 ?? "")\( strIngredient5 ?? "")\n\(strMeasure6 ?? "")\(strIngredient6 ?? "")\n\(strMeasure7 ?? "")\(strIngredient7 ?? "")\n\(strMeasure8 ?? "")\(strIngredient8 ?? "")\n\(strMeasure9 ?? "")\(strIngredient9 ?? "")\n\(strMeasure10 ?? "")\(strIngredient10 ?? "")\n\(strMeasure11 ?? "")\(strIngredient11 ?? "")\n\(strMeasure12 ?? "")\(strIngredient12 ?? "")\n\(strMeasure13 ?? "")\(strIngredient13 ?? "")\n\(strMeasure14 ?? "")\(strIngredient14 ?? "")\n\(strMeasure15 ?? "")\(strIngredient15 ?? "")".clean()
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

extension String {
    func clean() -> String {        
        var result = self
        var i: Int = self.count - 1
        while !self[i].isLetter && !self[i].isNumber {
            result = String(result.dropLast())
            i -= 1
        }
        return result
    }
}
