//
//  UserSettingsViewController.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 14.04.23.
//

import UIKit
import FirebaseAuth
import SPIndicator

class UserSettingsViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    weak var delegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = Auth.auth().currentUser {
            if let name = user.displayName {
                nameTextField.text = name
            }
            
            guard let email = user.email else { return }
            
            emailTextField.text = email
        } else {
            // TODO: handle error with the help of SPIndicator
            // and dismiss
            SPIndicator.present(title: "Please login🥹",message: "Log in to change your profile", preset: .error, haptic: .error, from: .top)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveChangesAction(_ sender: Any) {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        
        let alertVC = UIAlertController(title: "Save changes?", message: "Are you sure to make changes?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            if let user = Auth.auth().currentUser {
                let changeProfileRequest = user.createProfileChangeRequest()
                changeProfileRequest.displayName = name
                if let emailDb = user.email,
                   emailDb != email {
                    user.updateEmail(to: email) { error in
                        if let error {
                            SPIndicator.present(title: "Error", message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
                        } else {
                            SPIndicator.present(title: "Success", message: "Please check your email for confirm new email", preset: .done, haptic: .success, from: .top)
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
                if password.count > 5 {
                    user.updatePassword(to: password)
                } else {
                    SPIndicator.present(title: "Error", message: "Password has less than 6 symbols", preset: .error, haptic: .error, from: .top)
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                
                changeProfileRequest.commitChanges { error in
                    if let error {
                        SPIndicator.present(title: "Error", message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
                    } else {
                        SPIndicator.present(title: "Success", message: "Please check your email for confirm new email", preset: .done, haptic: .success, from: .top)
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        alertVC.addAction(yesAction)
        let noAction = UIAlertAction(title: "NO", style: .destructive) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertVC.addAction(noAction)
        self.present(alertVC, animated: true)
    }
}

