//
//  LoginVC.swift
//  Corn Tab
//
//  Created by StarsDev on 11/07/2023.

import UIKit
import LocalAuthentication

class LoginVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var logInTxt: UITextField!
    @IBOutlet weak var passWordTxt: UITextField!
    @IBOutlet weak var eyeBtn: UIButton!
    // MARK: - Properties
    let textFieldDelegateHelper = TextFieldDelegateHelper()
    var isPasswordVisible = false
    var connectString = ""
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldHelper()
        setupEyeButton()
        authenticateWithBiometrics()
    }
    // MARK: - Actions
    @IBAction func continueBtnTap(_ sender: UIButton) {
        apiCall()
    }
    @IBAction func backBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pinVC = storyboard.instantiateViewController(withIdentifier: "PinVC") as! PinVC
        let navVC = UINavigationController(rootViewController: pinVC)
        navVC.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        UserDefaults.standard.set("", forKey: "connectString")
        UserInfo.shared.isUserLoggedIn = false
    }
    @IBAction func eyeBtnTap(_ sender: UIButton) {
        isPasswordVisible.toggle()
        updatePasswordVisibility()
    }
    @IBAction func fingerPrintBtn(_ sender: UIButton) {
        authenticateWithBiometrics()
    }
    // MARK: - Helper Methods
    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let localizedReason = "Authenticate with your fingerprint to log in"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { [weak self] (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        // Authentication successful, user's fingerprint matched.
                        self?.apiCall() // Call your existing API method after successful authentication.
                    } else {
                        // Authentication failed or user canceled.
                        if let authenticationError = authenticationError {
                            print("Authentication failed: \(authenticationError.localizedDescription)")
                        }
                    }
                }
            }
        } else {
            // Biometric authentication is not available or not configured.
            print("Biometric authentication not available: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
    func setupEyeButton() {
        eyeBtn.setImage(UIImage(systemName: isPasswordVisible ? "eye" : "eye.slash"), for: .normal)
    }
    func updatePasswordVisibility() {
        passWordTxt.isSecureTextEntry = !isPasswordVisible
        setupEyeButton()
    }
    func textFieldHelper() {
        textFieldDelegateHelper.configureTapGesture(for: view)
        logInTxt.delegate = textFieldDelegateHelper
        passWordTxt.delegate = textFieldDelegateHelper
    }
    // MARK: - POST API Calling
    func apiCall() {
        guard let username = logInTxt.text, !username.isEmpty,
              let password = passWordTxt.text, !password.isEmpty else {
            showAlert(title: "Alert", message: "Please enter both username and password")
            return
        }
        let parameters = [
            "UserName": username,
            "Password": password,
            "Grant_Type": "password"
        ]
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Error creating JSON data.")
            return
        }
        let endpoint = APIConstants.Endpoints.login
        let urlString = APIConstants.baseURL + endpoint
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        var request = URLRequest(url: url)
        let conString = UserDefaults.standard.string(forKey: "connectString") ?? ""
        request.addValue(conString, forHTTPHeaderField: "x-conn")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        let loadingAlert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        loadingAlert.addActivityIndicator()
        present(loadingAlert, animated: true, completion: nil)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Data not received.")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Response JSON: \(json)")
                    // Handle the JSON data as needed
                    if let status = json["Status"] as? Bool, status {
                        let accessToken = json["Access_Token"] as? String
                        let userinfo = json["UerInfo"] as? NSDictionary
                        let username = userinfo?["UserName"] as? String
                        let userId = userinfo?["UserId"] as? Int
                        let distributionName = userinfo?["DistributionName"] as? String
                        let WorkingDate = userinfo?["WorkingDate"] as? String
                        UserDefaults.standard.set(userId, forKey: "UserId")
                        UserDefaults.standard.set(username, forKey: "UserName")
                        UserDefaults.standard.set(WorkingDate, forKey: "WorkingDate")
                        UserDefaults.standard.set(accessToken, forKey: "Access_Token")
                        UserInfo.shared.isUserLoggedIn = true
                        
                        APIManager.makePOSTRequest { (data) in
                            // Handle API response (including errors) and save data to UserDefaults
                            if let dataToSave = try? JSONEncoder().encode(data) {
                                UserDefaults.standard.set(dataToSave, forKey: "parsedDataKey")
                            }
                            
                            // Dismiss loading indicator or navigate to your app's main screen
                        }
                        
                        //                        DispatchQueue.main.async {
                        //                            loadingAlert.dismiss(animated: true, completion: nil)
                        //                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        //                            let nextVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                        //                            nextVC.userName = username ?? ""
                        //                            nextVC.distributionName = distributionName ?? ""
                        //                            nextVC.workingDate = WorkingDate ?? ""
                        //                            self.navigationController?.pushViewController(nextVC, animated: true)
                        //                        }
                        
                        DispatchQueue.main.async {
                            loadingAlert.dismiss(animated: true, completion: {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let nextVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                                nextVC.userName = username ?? ""
                                nextVC.distributionName = distributionName ?? ""
                                nextVC.workingDate = WorkingDate ?? ""
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            })
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(title: "Alert", message: "Invalid username or password")
                            loadingAlert.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }
}
