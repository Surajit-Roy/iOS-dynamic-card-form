//
//  ViewController.swift
//  pineLabAddCardPOC
//
//  Created by Surajit on 18/03/25.
//

import UIKit

class ViewController: ParentController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var cardHolderTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expiryDateTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    
    @IBOutlet weak var errorCardHolderLabel: UILabel!
    @IBOutlet weak var errorCardNumberLabel: UILabel!
    @IBOutlet weak var errorExpiryDateLabel: UILabel!
    @IBOutlet weak var errorCVVLabel: UILabel!
    
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    internal var cardCellWidth = (3 / 3.75) * UIScreen.main.bounds.width //300
    internal var isScrollingLeftToRight: Bool = false
    internal var cardLayout = PagingCollectionViewLayout()
    
    var cards: [DebitCardModel] = [
        DebitCardModel(cardHolder: "", cardNumber: "", expiry: "", cvv: "", flipState: false),
        DebitCardModel(cardHolder: "", cardNumber: "", expiry: "", cvv: "", flipState: false),
        DebitCardModel(cardHolder: "", cardNumber: "", expiry: "", cvv: "", flipState: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        payBtn.setupGradient(gradientColor: [UIColor.systemBlue.cgColor, UIColor.black.cgColor])
        showCardLayoutBasedOnData()
        hideAllErrorMessages()
        collectionView.delegate = self
        collectionView.dataSource = self
        cardLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = cardLayout
        collectionView.showsHorizontalScrollIndicator = false
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//            layout.minimumLineSpacing = 16 // Space between cards
//        }
        
        pageControl.numberOfPages = cards.count
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        
        cardHolderTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cardNumberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        expiryDateTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cvvTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        cvvTextField.addTarget(self, action: #selector(cvvTextFieldDidBeginEditing(_:)), for: .editingDidBegin)
        cvvTextField.addTarget(self, action: #selector(cvvTextFieldDidEndEditing(_:)), for: .editingDidEnd)
        
        cardNumberTextField.keyboardType = .numberPad
        expiryDateTextField.keyboardType = .numberPad
        cvvTextField.keyboardType = .numberPad
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DebitCardCell", for: indexPath) as! DebitCardCell
        let card = cards[indexPath.item]
        cell.configure(with: card)
        return cell
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        
        if pageControl.currentPage != pageIndex {
            pageControl.currentPage = pageIndex
            
            // Clear text fields
            cardHolderTextField.text = ""
            cardNumberTextField.text = ""
            expiryDateTextField.text = ""
            cvvTextField.text = ""
            
            if let cell = collectionView.cellForItem(at: IndexPath(item: pageIndex, section: 0)) as? DebitCardCell {
                cell.cardHolderLabel.text = ""
                cell.cardNumberLabel.text = ""
                cell.expiryLabel.text = ""
                cell.cvvLabel.text = ""
                
                cell.frontView.isHidden = false
                cell.backView.isHidden = true
            }
            
            if pageIndex < cards.count {
                cards[pageIndex] = DebitCardModel(cardHolder: "", cardNumber: "", expiry: "", cvv: "", flipState: false)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let currentIndex = pageControl.currentPage
        guard let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? DebitCardCell else { return }

        var card = cards[currentIndex]

        if textField == cardHolderTextField {
            card.cardHolder = textField.text ?? ""
            cell.cardHolderLabel.text = card.cardHolder
            validateField(cardHolderTextField, errorLabel: errorCardHolderLabel, errorMessage: "Cardholder name is required") { $0.count >= 3 }
        }
        else if textField == cardNumberTextField {
            let formattedText = formatCardNumber(textField.text ?? "")
            textField.text = formattedText
            card.cardNumber = formattedText.replacingOccurrences(of: " ", with: "")
            cell.cardNumberLabel.text = formattedText
            validateField(cardNumberTextField, errorLabel: errorCardNumberLabel, errorMessage: "Enter a valid 16-digit card number") { $0.replacingOccurrences(of: " ", with: "").count == 16 }
        }
        else if textField == expiryDateTextField {
            let formattedText = formatExpiryDate(textField.text ?? "")
            textField.text = formattedText
            card.expiry = formattedText
            cell.expiryLabel.text = formattedText
            validateField(expiryDateTextField, errorLabel: errorExpiryDateLabel, errorMessage: "Enter a valid expiry date (MM/YY)") { $0.count == 5 }
        }
        else if textField == cvvTextField {
            let cleanedText = textField.text?.filter { $0.isNumber } ?? ""
            textField.text = String(cleanedText.prefix(3)) // Max 3 digits
            card.cvv = textField.text ?? ""
            cell.cvvLabel.text = card.cvv
            validateField(cvvTextField, errorLabel: errorCVVLabel, errorMessage: "Enter a valid 3-digit CVV") { $0.count == 3 }
        }

        cards[currentIndex] = card
    }
    
    @objc func cvvTextFieldDidBeginEditing(_ textField: UITextField) {
        let currentIndex = pageControl.currentPage
        guard let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? DebitCardCell else { return }
        
        if !cards[currentIndex].flipState {
            flipCard(cell)
            cards[currentIndex].flipState = true
        }
    }

    @objc func cvvTextFieldDidEndEditing(_ textField: UITextField) {
        let currentIndex = pageControl.currentPage
        guard let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? DebitCardCell else { return }
        
        if cards[currentIndex].flipState {
            flipCard(cell)
            cards[currentIndex].flipState = false
        }
    }
    
    // Common Validation for Pay Button
    private func validateAllFields() -> Bool {
        var isValid = true

        isValid = validateField(cardHolderTextField, errorLabel: errorCardHolderLabel, errorMessage: "Cardholder name is required") { $0.count >= 3 } && isValid

        isValid = validateField(cardNumberTextField, errorLabel: errorCardNumberLabel, errorMessage: "Enter a valid 16-digit card number") { $0.replacingOccurrences(of: " ", with: "").count == 16 } && isValid

        isValid = validateField(expiryDateTextField, errorLabel: errorExpiryDateLabel, errorMessage: "Enter a valid expiry date (MM/YY)") { $0.count == 5 } && isValid

        isValid = validateField(cvvTextField, errorLabel: errorCVVLabel, errorMessage: "Enter a valid 3-digit CVV") { $0.count == 3 } && isValid

        return isValid
    }

    // Pay Button Action
    @IBAction func payButtonTapped(_ sender: UIButton) {
        hideAllErrorMessages() // Hide all errors first
        if validateAllFields() {
            print("✅ Payment Processing...")
        } else {
            print("❌ Validation Failed")
        }
    }
    
    // Hide All Error Messages Initially
    private func hideAllErrorMessages() {
        errorCardHolderLabel.text = ""
        errorCardNumberLabel.text = ""
        errorExpiryDateLabel.text = ""
        errorCVVLabel.text = ""
    }
    
    
    // MARK: - Debit Card Layout
    internal func showCardLayoutBasedOnData(height: CGFloat = 0.0) {
    if cards.count == 1 {
        cardLayout.itemSize = CGSize(width: ScreenSize.width-40, height: 180)
        cardLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    } else {
        cardLayout.itemSize = CGSize(width: self.cardCellWidth, height: 180)
        cardLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        }
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let currentContentXOffset = scrollView.contentOffset.x
        let proposedContentXOffset = targetContentOffset.pointee.x

        let proposedContentOffset = targetContentOffset.pointee
        let currentIndex = cardLayout.currentIndex(forContentOffset: proposedContentOffset)
        
        isScrollingLeftToRight = proposedContentXOffset > currentContentXOffset

        pageControl.currentPage = currentIndex
        
        self.view.endEditing(true)
        if cards.count == 1 {
            cardLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        } else {
            if (currentIndex+1)  >= (cards.count ?? 0) {
                cardLayout.itemSize = CGSize(width: self.cardCellWidth, height: 180)
                cardLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            } else if currentIndex > 0 {
                cardLayout.itemSize = CGSize(width: self.cardCellWidth, height: 180)
                let setLeftValue:CGFloat = isScrollingLeftToRight ? 55 : 55
                let setRightValue:CGFloat = !isScrollingLeftToRight ? 15 : 30
                cardLayout.sectionInset = UIEdgeInsets(top: 0, left: setLeftValue, bottom: 0, right: setRightValue)
                DispatchQueue.main.async{
                    self.collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
                }
            } else {
                cardLayout.itemSize = CGSize(width: self.cardCellWidth, height: 180)
                cardLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
                DispatchQueue.main.async{
                    self.collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
}
