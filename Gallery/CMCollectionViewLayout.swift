//
//  CMCollectionViewLayout.swift
//  Gallery
//
//  Created by changmin lee on 2020/02/03.
//  Copyright © 2020 changmin lee. All rights reserved.
//

import Foundation
import UIKit

class CMCollectionViewLayout: UICollectionViewLayout {
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    var sideInsetSize : CGFloat {
        return 0
    }
    
    var numberOfCell: Int {
        return self.collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    var collectionViewSize: CGSize {
        return CGSize(width: collectionView?.frame.width ?? 0,
                      height: collectionView?.frame.height ?? 0)
    }
    
    override var collectionViewContentSize: CGSize {
        guard numberOfCell != 0 else { return CGSize.zero }
        
        let width = collectionViewSize.width
        let height = CGFloat((numberOfCell - 1) / 3 + 1) * cellSize.height
        return CGSize(width: width, height: height)
    }
    
    
    var cellSize: CGSize {
        let size = ( collectionViewSize.width / 3)
        return CGSize( width : size, height : size )
    }
    
    override func prepare() {
        cache.removeAll()
        for row in 0..<numberOfCell {
            let attribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: row, section: 0))
            attribute.frame = getFrame(at: row)
            cache.append(attribute)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
    
    func getFrame(at row: Int) -> CGRect {
        let x = cellSize.width * CGFloat(row % 3)
        let y = cellSize.height * CGFloat(row / 3)
        return CGRect(x: x, y: y, width: cellSize.width, height: cellSize.height)
    }
}
