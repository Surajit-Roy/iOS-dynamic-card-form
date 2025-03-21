//
//  ParentController.swift
//  pineLabAddCardPOC
//
//  Created by Surajit on 19/03/25.
//

import UIKit

class ParentController: UIViewController {
    
    // MARK: - TextField Validation
    internal func validateField(_ textField: UITextField, errorLabel: UILabel, errorMessage: String, validation: (String) -> Bool) -> Bool {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if validation(text) {
            errorLabel.text = ""
            return true
        } else {
            errorLabel.text = errorMessage
            return false
        }
    }
    

    
    // MARK: - Card Flip Method
    func flipCard(_ cell: DebitCardCell) {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

        UIView.transition(with: cell, duration: 0.5, options: transitionOptions, animations: {
            cell.frontView.isHidden.toggle()
            cell.backView.isHidden.toggle()
        })
    }
    
    // MARK: - Formatting Methods

    internal func formatCardNumber(_ text: String) -> String {
        let digits = text.filter { $0.isNumber }
        let trimmed = String(digits.prefix(16)) // Max 16 digits

        var formatted = ""
        for (index, char) in trimmed.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted.append(" ")
            }
            formatted.append(char)
        }
        return formatted
    }

    internal func formatExpiryDate(_ text: String) -> String {
        let digits = text.filter { $0.isNumber }
        guard !digits.isEmpty else { return "" }

        var formatted = ""

        // Extract and validate month
        if digits.count >= 1 {
            let firstDigit = String(digits.prefix(1)) // Convert to String
            if firstDigit == "0" || firstDigit == "1" {
                formatted.append(firstDigit)
            } else {
                formatted.append("0") // Auto-correct invalid first digit
                formatted.append(firstDigit)
            }
        }

        if digits.count >= 2 {
            let secondDigit = String(digits.prefix(2).suffix(1)) // Convert to String
            let month = Int(formatted + secondDigit) ?? 0
            if (1...12).contains(month) {
                formatted.append(secondDigit)
            } else {
                return formatted // Stop if month is invalid
            }
        }

        // Add separator
        if digits.count > 2 {
            formatted.append("/")
            formatted.append(contentsOf: digits.dropFirst(2).prefix(2)) // Add last 2 digits for year
        }

        // Validate month & year against the current date
        if formatted.count == 5 {
            let inputMonth = Int(formatted.prefix(2)) ?? 0
            let inputYear = Int(formatted.suffix(2)) ?? 0
            let currentDate = Date()
            let calendar = Calendar.current
            let currentMonth = calendar.component(.month, from: currentDate)
            let currentYear = calendar.component(.year, from: currentDate) % 100

            // Reject if the entered year is in the past
            if inputYear < currentYear {
                return String(formatted.prefix(3)) // Keep MM/ but reject past year
            }

            // Reject if the month is before the current month in the same year
            if inputYear == currentYear && inputMonth < currentMonth {
                return String(formatted.prefix(3)) // Keep MM/ but reject past month
            }
        }

        return formatted
    }
}
