//
//  Utilities.swift
//  pineLabAddCardPOC
//
//  Created by Surajit on 19/03/25.
//

import Foundation
import UIKit

struct ScreenSize {
    static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
    static let bounds = UIScreen.main.bounds
    
    static func getCurrentScreen() -> DeviceType{
        switch ScreenSize.height{
        case 600...700:
            return .smallerScreen
        case 701...750:
            return .mediumScreen
        default:
            return .bigScreen
        }
    }
}

enum DeviceType:Int{
    case bigScreen
    case mediumScreen
    case smallerScreen
}

//MARK: Collectionview center align and scroll one at a time
class PagingCollectionViewLayout: UICollectionViewFlowLayout {

    var velocityThresholdPerPage: CGFloat = 2
    var numberOfItemsPerPage: CGFloat = 1

    func currentIndex(forContentOffset contentOffset: CGPoint) -> Int {
        let pageLength: CGFloat
        let approxPage: CGFloat

        if scrollDirection == .horizontal {
            pageLength = (itemSize.width + minimumLineSpacing) * numberOfItemsPerPage
            approxPage = contentOffset.x / pageLength
        } else {
            pageLength = (itemSize.height + minimumLineSpacing) * numberOfItemsPerPage
            approxPage = contentOffset.y / pageLength
        }

        return Int(approxPage.rounded())
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }

        let pageLength: CGFloat
        let approxPage: CGFloat
        let currentPage: CGFloat
        let speed: CGFloat

        if scrollDirection == .horizontal {
            pageLength = (itemSize.width + minimumLineSpacing) * numberOfItemsPerPage
            approxPage = collectionView.contentOffset.x / pageLength
            speed = velocity.x
        } else {
            pageLength = (itemSize.height + minimumLineSpacing) * numberOfItemsPerPage
            approxPage = collectionView.contentOffset.y / pageLength
            speed = velocity.y
        }

        if speed < 0 {
            currentPage = ceil(approxPage)
        } else if speed > 0 {
            currentPage = floor(approxPage)
        } else {
            currentPage = round(approxPage)
        }

        guard speed != 0 else {
            if scrollDirection == .horizontal {
                return CGPoint(x: currentPage * pageLength, y: 0)
            } else {
                return CGPoint(x: 0, y: currentPage * pageLength)
            }
        }

        var nextPage: CGFloat = currentPage + (speed > 0 ? 1 : -1)

        let increment = speed / velocityThresholdPerPage
        nextPage += (speed < 0) ? ceil(increment) : floor(increment)

        if scrollDirection == .horizontal {
            return CGPoint(x: nextPage * pageLength, y: 0)
        } else {
            return CGPoint(x: 0, y: nextPage * pageLength)
        }
    }
    
    
}


extension UIView {
    // MARK: - view Gradient
    internal func setupGradient(gradientColor: [CGColor], startPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColor
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.cornerRadius = 15
        gradientLayer.frame = self.bounds

        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
