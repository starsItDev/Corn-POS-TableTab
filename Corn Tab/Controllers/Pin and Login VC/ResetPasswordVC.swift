//
//  RestPasswordVC.swift
//  Corn Tab
//
//  Created by StarsDev on 11/07/2023.
//

import UIKit

class ResetPasswordVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var emailTxt: UITextField!
    // MARK: - Properties
    let textFieldDelegateHelper = TextFieldDelegateHelper()
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldHelper()
    }
    // MARK: - Actions
    @IBAction func sendBtnTap(_ sender: UIButton) {
        guard let email = emailTxt.text, !email.isEmpty else {
            showAlert(title: "Alert", message: "Please enter your email")
            return
        }
        // Perform password reset functionality here
        
        // Display success or failure message
        showAlert(title: "Success", message: "Password reset email sent to \(email)")
    }
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Helper Methods
    func textFieldHelper() {
        textFieldDelegateHelper.configureTapGesture(for: view)
        emailTxt.delegate = textFieldDelegateHelper
    }
}
