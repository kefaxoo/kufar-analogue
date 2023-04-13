//
//  SignViewController.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 13.04.23.
//

import UIKit
import FirebaseAuth
import SPIndicator

class SignViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    private var signType: SignType = .signIn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInterface()
    }
    
    private func setInterface() {
        if signType == .signIn {
            forgetPasswordButton.isHidden = false
            signInButton.isHidden = false
        } else if signType == .signUp {
            forgetPasswordButton.isHidden = true
            signInButton.isHidden = true
        }
    }
    
    @IBAction func forgetPasswordAction(_ sender: Any) {
        guard let email = emailTextField.text else {
            SPIndicator.present(title: "Email is empty", preset: .error, haptic: .error, from: .top)
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                SPIndicator.present(title: "Error sending password reset email", message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
            } else {
                SPIndicator.present(title: "Password reset email sent", preset: .done, haptic: .success, from: .top)
            }
        }
    }
    
    @IBAction func signInAction(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                SPIndicator.present(title: "Error signing in", message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
            } else {
                if let user = Auth.auth().currentUser {
                    if user.isEmailVerified {
                        SPIndicator.present(title: "Success login", preset: .done, haptic: .success, from: .top)
                        self.dismiss(animated: true)
                    } else {
                        SPIndicator.present(title: "Verify email", preset: .error, haptic: .error, from: .top)
                    }
                }
            }
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if signType == .signIn {
            signType = .signUp
            UIView.animate(withDuration: 1) {
                self.setInterface()
            }
        } else if signType == .signUp {
            guard let email = emailTextField.text,
                  let password = passwordTextField.text
            else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error {
                    SPIndicator.present(title: "Error creating user", message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
                } else {
                    guard let authResult else { return }
                    
                    authResult.user.sendEmailVerification(completion: { error in
                        if let error = error {
                            SPIndicator.present(title: "Error sending verification email", message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
                        } else {
                            SPIndicator.present(title: "Verification email sent", message: "Check your email and verify account", preset: .done, haptic: .success, from: .top)
                            self.signType = .signIn
                            UIView.animate(withDuration: 1) {
                                self.setInterface()
                            }
                        }
                    })
                }
            }
        }
    }
    
}
