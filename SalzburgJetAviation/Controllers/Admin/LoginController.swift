//
//  LoginController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import SVProgressHUD

enum LoginReturnValue: String {
    
    case success = "success"
    case invalidUsername = "invalid_username"
    case incorrectPassword = "incorrect_password"
    case restForbiden = "rest_forbidden"
    case error = "error"
    
}

class LoginController: UIViewController {
    
    var settingDelegate: SettingControllerDelegate?
    
    let usernameTextField: ToplessTextField = {
        let textField = ToplessTextField()
        let str = NSAttributedString(string: "USER", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25)])
        textField.attributedPlaceholder = str
        textField.textColor = .white
        textField.borderColor = .gray
        return textField
    }()
    
    let passwordTextField: ToplessTextField = {
        let textField = ToplessTextField()
        let str = NSAttributedString(string: "PASS", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25)])
        textField.attributedPlaceholder = str
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.borderColor = .gray
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.tintColor = .gray
        button.backgroundColor = StyleGuideManager.mainYellowColor
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
}

extension LoginController {
    
    @objc fileprivate func handleLogin() {
        if !(checkInvalid()) {
            return
        }
        
        handleLoginForAdmin()
        
//        fetchAirports()
    }
    
    private func handleFinishLogin() {
        UserDefaults.standard.setIsLoggedIn(value: true)
        UserDefaults.standard.setUsername(self.usernameTextField.text!)
        UserDefaults.standard.setPassword(self.passwordTextField.text!)
        
        handleDismissController()
        self.settingDelegate?.handleLoginAfterDismiss()
    }
    
    private func handleLoginForAdmin() {
        
        guard let username = self.usernameTextField.text, let password = self.passwordTextField.text else { return }
        
        let base64String = (username + ":" + password).toBase64()
        
        APIService.sharedInstance.HandleAdmonLogin(WithUrlString: WebService.adminLogin.rawValue, base64Str: base64String) { (result) in
            
            print("admin login result: ", result)
            
            if result == LoginReturnValue.success.rawValue {
                self.fetchAirports()
            } else if result == LoginReturnValue.restForbiden.rawValue {
                self.showErrorMessage("Sorry, you are not allowed to do that.")
            } else if result == LoginReturnValue.invalidUsername.rawValue {
                self.showErrorMessage("Invalid username!")
            } else if result == LoginReturnValue.incorrectPassword.rawValue {
                self.showErrorMessage("Password is incorrect")
            } else {
                self.showErrorMessage("Something went wrong!\nTry again later.")
            }
            
        }
        
    }
    
    private func fetchAirports() {
        
        APIService.sharedInstance.fetchAirPorts { (airports: [Airport]) in
            
            var success = false
            SQLiteHelper.delete(inTable: "airports")
//            SQLiteHelper.delete(inTable: "aircraft_departure_airport")
//            SQLiteHelper.delete(inTable: "aircraft_destination_airport")
            
            for airport in airports {
                
                let encodedAirport = getEncodedAirport(FromAirport: airport)
                if let airportDictionary = encodedAirport.dictionary {
                    
                    success = SQLiteHelper.insert(inTable: "airports", params: airportDictionary)
                }
            }
            
            if success {
                DispatchQueue.main.async {
                    self.handleFinishLogin()
                }
            } else {
                self.showErrorMessage("Something went wrong!\nTry again later.")
            }
        }
    }
    
    
    
    private func showErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showJHTAlerttOkayWithIcon(message: message)
        }
    }
    
    @objc fileprivate func handleDismissController() {
        
        navigationController?.popViewController(animated: true)
        
    }
}

//MARK: check valid
extension LoginController {
    
    fileprivate func checkInvalid() -> Bool {
        
        if (usernameTextField.text?.isEmptyStr)! || !self.isValidUsername(usernameTextField.text!) {
            self.showJHTAlerttOkayWithIcon(message: "Invalid Username!\nPlease type valid Username")
            return false
        }
        
        if (passwordTextField.text?.isEmptyStr)! || !self.isValidPassword(passwordTextField.text!) {
            self.showJHTAlerttOkayWithIcon(message: "Invalid Password!\nPlease type valid Password")
            return false
        }
        return true
    }
    
    fileprivate func isValidEmail(_ email: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    fileprivate func isValidUsername(_ username: String) -> Bool {
//        if username == "Admin" {
//            return true
//        } else {
//            return false
//        }
        return true
    }
    
    fileprivate func isValidPassword(_ password: String) -> Bool {
//        if password == "Admin123" {
//            return true
//        } else {
//            return false
//        }
        return true
    }
}


extension LoginController {
    
    fileprivate func setupViews() {
        
        setupBackgrounds()
        setupTextFields()
        setupLoginButton()
    }
    
    private func setupLoginButton() {
        
        view.addSubview(loginButton)
        
        _ = loginButton.anchor(passwordTextField.bottomAnchor, left: passwordTextField.leftAnchor, bottom: nil, right: passwordTextField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
    }
    
    private func setupTextFields() {
        
        view.addSubview(passwordTextField)
        view.addSubview(usernameTextField)
        
        _ = passwordTextField.anchor(nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 50)
        passwordTextField.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        _ = usernameTextField.anchor(nil, left: passwordTextField.leftAnchor, bottom: passwordTextField.topAnchor, right: passwordTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        let lineView = UIView()
        lineView.backgroundColor = .gray
        
        view.addSubview(lineView)
        
        _ = lineView.anchor(nil, left: passwordTextField.leftAnchor, bottom: usernameTextField.topAnchor, right: passwordTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 2)
    }
    
    private func setupBackgrounds() {
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = StyleGuideManager.mainBackgroundColor
        
        let loginLabel = UILabel()
        loginLabel.text = "Log In"
        loginLabel.textAlignment = .center
        loginLabel.textColor = .white
        loginLabel.font = UIFont.systemFont(ofSize: 23)
        
        view.addSubview(loginLabel)
        
        _ = loginLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        
        let backButton = UIButton(type: .system)
        let backImage = UIImage(named: AssetName.leftArrow.rawValue)?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(handleDismissController), for: .touchUpInside)
        
        view.addSubview(backButton)
        
        _ = backButton.anchor(nil, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        backButton.centerYAnchor.constraint(equalTo: loginLabel.centerYAnchor).isActive = true
    }
    
}
