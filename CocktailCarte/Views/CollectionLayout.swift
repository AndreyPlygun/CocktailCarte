//
//  CollectionViewLayout.swift
//  CoctailDB
//
//  Created by Andrey Plygun on 12/4/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class CollectionLayout: UICollectionViewLayout {
    var attributes = [UICollectionViewLayoutAttributes]()
    var contentHeight: CGFloat = 0
    var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.bounds.width
    }
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        attributes.removeAll()
        guard let collectionView = collectionView else { return }
        
        var rowPadding: CGFloat = 5
        let columnPadding: CGFloat = 15
//        let cellWidth: CGFloat = 120 //(UIScreen.main.bounds.width / 3) - rowPadding * 2
//        let cellHeight: CGFloat = 200 //cellWidth * 1.59
        let cellWidth = (UIScreen.main.bounds.width / 3) - rowPadding * 2
        let cellHeight = cellWidth * 1.4
        
        let numberOfColumns = Int(floor(contentWidth / (cellWidth + rowPadding)))
        rowPadding = contentWidth.truncatingRemainder(dividingBy: cellWidth) / CGFloat(numberOfColumns * 2)
        var xOffsets = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffsets.append(CGFloat(column) * (cellWidth + rowPadding * 2))
        }
        var yOffset: CGFloat = rowPadding
        var column = 0
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let frame = CGRect(x: xOffsets[column] + rowPadding, y: yOffset, width: cellWidth, height: cellHeight)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attr.frame = frame
            attributes.append(attr)
            contentHeight = frame.maxY + rowPadding
            if column < numberOfColumns - 1 {
                column += 1
            } else {
                column = 0
                yOffset += cellHeight + columnPadding
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attr in attributes {
            if attr.frame.intersects(rect) {
                visibleLayoutAttributes.append(attr)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[indexPath.item]
    }
    
}
