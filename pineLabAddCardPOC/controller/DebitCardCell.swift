//
//  DebitCardCell.swift
//  pineLabAddCardPOC
//
//  Created by Surajit on 18/03/25.
//

import UIKit

class DebitCardCell: UICollectionViewCell {
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var backView: UIView!
    
    // Labels for Front Side
    @IBOutlet weak var cardHolderLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    
    // Label for Back Side
    @IBOutlet weak var cvvLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupRoundedCorners()
        frontView.setupGradient(gradientColor: [UIColor.black.cgColor, UIColor.purple.cgColor, UIColor.systemBlue.cgColor, UIColor.black.cgColor], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
        backView.setupGradient(gradientColor: [UIColor.black.cgColor, UIColor.purple.cgColor, UIColor.systemBlue.cgColor, UIColor.black.cgColor], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
    }
    
    func configure(with card: DebitCardModel) {
        cardHolderLabel.text = card.cardHolder
        cardNumberLabel.text = card.cardNumber
        expiryLabel.text = card.expiry
        cvvLabel.text = card.cvv
        
        frontView.isHidden = false
        backView.isHidden = true
    }
    
    private func setupRoundedCorners() {
        frontView.layer.cornerRadius = 15
        frontView.layer.masksToBounds = true
        
        backView.layer.cornerRadius = 15
        backView.layer.masksToBounds = true
    }
}


