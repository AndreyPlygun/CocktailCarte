//
//  RealmModel.swift
//  CoctailDB
//
//  Created by Andrey Plygun on 9/12/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class DrinkShort: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var isLiked: Bool = false
    @objc dynamic var category: String = ""
    @objc dynamic var ingredients: String = ""
    @objc dynamic var instructions: String = ""
    @objc dynamic var glass: String = ""
}
