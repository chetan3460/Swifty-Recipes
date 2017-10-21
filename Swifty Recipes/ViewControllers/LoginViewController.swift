//
//  LoginViewController.swift
//  Swifty Recipes
//
//  Created by Frank Ehlers on 20.10.17.
//  Copyright © 2017 Frank Ehlers. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func segmentedControlHandler(_ sender: UISegmentedControl) {
        confirmButton.setTitle(sender.titleForSegment(at: sender.selectedSegmentIndex), for: .normal)
        
        
    }
    @IBAction func buttonHandler(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            Utility.showAlertView(with: "No Email", and: "Please enter a email address", in: self)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            Utility.showAlertView(with: "No Password", and: "Please enter a password", in: self)
            return
        }
        
        SVProgressHUD.show()
        
        if sender.titleLabel?.text == "Login" { // User einloggen
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                SVProgressHUD.dismiss()
                if let error = error {
                    switch error {
                    case AuthErrorCode.invalidEmail:
                        Utility.showAlertView(with: "Invalid Email", and: "Please enter a valid Email", in: self)
                    case AuthErrorCode.wrongPassword:
                        Utility.showAlertView(with: "Wrong password", and: "The password for this email is wrong", in: self)
                    default:
                        break
                    }
                } else {
                    if let user = user {
                        UserDefaults.standard.set(user.uid, forKey: "userID")
                        self.performSegue(withIdentifier: "SignInSegue", sender: nil)
                    }
                    
                }
            })
        } else { // User registrieren
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                SVProgressHUD.dismiss()
                if let error = error {
                    switch error {
                    case AuthErrorCode.emailAlreadyInUse:
                        Utility.showAlertView(with: "Email already in use", and: "Please choose a different email address", in: self)
                    case AuthErrorCode.invalidEmail:
                        Utility.showAlertView(with: "Invalid Email", and: "Please enter a valid Email", in: self)
                    case AuthErrorCode.weakPassword:
                        Utility.showAlertView(with: "Weak password", and: "Please choose a password that contains at least 6 characters", in: self)
                    default:
                        break
                    }
                } else {
                    if let user = user {
                        UserDefaults.standard.set(user.uid, forKey: "userID")
                        self.performSegue(withIdentifier: "SignInSegue", sender: nil)
                    }
                }
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }


}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
