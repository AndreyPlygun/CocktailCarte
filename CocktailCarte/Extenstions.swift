//
//  Extenstions.swift
//  CoctailDB
//
//  Created by Andrey Plygun on 12/4/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

// Storyboard
struct Storyboard {    
    static let about = UIStoryboard(name: "About", bundle: nil)
}



extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self.self)
    }
}

extension UIStoryboard {
    func controller<T: UIViewController>(withClass: T.Type) -> T? {
        let identifier = withClass.identifier
        return instantiateViewController(withIdentifier: identifier) as? T
    }
    
    func instantiateViewController<T: StoryboardIdentifiable>() -> T? {
        return instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T
    }
}


// UIViewController
extension UIViewController {
    class var identifier: String {
        let separator = "."
        let fullName = String(describing: self)
        if fullName.contains(separator) {
            let items = fullName.components(separatedBy: separator)
            if let name = items.last {
                return name
            }
        }
        return fullName
    }
}

extension UIViewController: StoryboardIdentifiable {}
protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}
