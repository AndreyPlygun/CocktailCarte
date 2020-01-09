//
//  CategoryCell.swift
//  CoctailDB
//
//  Created by Andrey Plygun on 04/12/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import SDWebImage

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func customInit(category: String) {
        lbName.text = category
        
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        AppLogic().getDrinkList(from: category) { [weak self] (drinks) in
            if let imageURL = drinks?.first?.imageURL, let url = URL(string: imageURL) {
                self?.imageView.sd_setImage(with: url, completed: nil)
            }
        }
    }

}
