//
//  SnapFlowLayout.swift
//  AutoscrollCollectionV
//
//  Created by boppo on 2/14/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit

class SnapFlowLayout : UICollectionViewFlowLayout{
    
    private var firstSetupDone = false
    
    override func prepare() {
        super.prepare()
        if !firstSetupDone {
            setup()
            firstSetupDone = true
        }
    }
    
    private func setup() {
        scrollDirection = .horizontal
        minimumLineSpacing = 10
        itemSize = CGSize(width: 200, height: 210)
        collectionView!.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let layoutAttributes = layoutAttributesForElements(in: collectionView!.bounds)
        
        let centerOffset = collectionView!.bounds.size.width / 2
        let offsetWithCenter = proposedContentOffset.x + centerOffset
        
        let closestAttribute = layoutAttributes!
            .sorted { abs($0.center.x - offsetWithCenter) < abs($1.center.x - offsetWithCenter) }
            .first ?? UICollectionViewLayoutAttributes()
        
        return CGPoint(x: closestAttribute.center.x - centerOffset, y: 0 )
        
    }
    
}
