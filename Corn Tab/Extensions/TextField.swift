//
//  TextField.swift
//  Corn Tab
//
//  Created by StarsDev on 17/07/2023.
//

import Foundation
import UIKit

class TextFieldDelegateHelper: NSObject, UITextFieldDelegate {
    
    var tapGesture: UITapGestureRecognizer?
    
    func configureTapGesture(for view: UIView) {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture?.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture!)
    }
    
    func removeTapGesture(from view: UIView) {
        view.removeGestureRecognizer(tapGesture!)
        tapGesture = nil
    }
    
    @objc func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
