//
//  PinVC.swift
//  Corn Tab
//
//  Created by StarsDev on 11/07/2023.
//
import UIKit

class PinVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var pinCodeTxt: UITextField!
    @IBOutlet weak var eyeBtn: UIButton!
    // MARK: - Properties
    let textFieldDelegateHelper = TextFieldDelegateHelper()
    var isPasswordVisible = false
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldHelper()
        setupUI()
    }
    // MARK: - Actions
    @IBAction func nextBtnTap(_ sender: UIButton) {
        apiCall()
    }
    @IBAction func eyeBtnTap(_ sender: UIButton) {
        isPasswordVisible.toggle()
        updatePasswordVisibility()
    }
    // MARK: - Helper Methods
    func setupUI() {
        eyeBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    func updatePasswordVisibility() {
        pinCodeTxt.isSecureTextEntry = !isPasswordVisible
        let eyeImageName = isPasswordVisible ? "eye" : "eye.slash"
        eyeBtn.setImage(UIImage(systemName: eyeImageName), for: .normal)
    }
    func textFieldHelper() {
        textFieldDelegateHelper.configureTapGesture(for: view)
        pinCodeTxt.delegate = textFieldDelegateHelper
    }
    func openLoginVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let navVC = UINavigationController(rootViewController: loginVC)
        navVC.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    //MARK: GET API Calling
    func apiCall() {
        guard let pin = pinCodeTxt.text, !pin.isEmpty else {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            showAlert(title: "Alert", message: "Text field is empty", actions: [okAction])
            return
        }
        let endpoint = APIConstants.Endpoints.getPin
        let urlString = APIConstants.baseURL + endpoint + "?Pin=\(pin)"
        
        Networking.instance.getApiCall(url: urlString) { (response, error, statusCode) in
            if let error = error {
                // Handle the API call error
                print("API call error: \(error)")
                return
            }
            if statusCode == 200 {
                // API call was successful, handle the response data
                let status = response["Status"].boolValue
                let connectString = response["ClientConnString"].stringValue
                UserDefaults.standard.set(connectString, forKey: "connectString")
                UserInfo.shared.isUserLoggedIn = true
                if status {
                    UserDefaults.standard.set(true, forKey: "isPINEntered")
                    self.openLoginVC()
                }
            } else {
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                self.showAlert(title: "Alert", message: "Wrong PIN entered.", actions: [okAction])
            }
        }
    }
}
