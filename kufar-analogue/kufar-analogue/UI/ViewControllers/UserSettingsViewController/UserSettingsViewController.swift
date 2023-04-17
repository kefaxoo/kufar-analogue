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
            navigationController?.popViewController(animated: true);
            
        }
    }
    
    @IBAction func saveChangesAction(_ sender: Any) {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        
        let alertVC = UIAlertController(title: "Save changes?", message: "Are you sure to make changes?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default) { _ in
            if var user = Auth.auth().currentUser {
                let changeProfireRequest = user.createProfileChangeRequest()
                changeProfireRequest.displayName = name
                if let emailDB = user.email,
                   emailDB != email {
                    user.updateEmail(to: email) { error in
                        if let error {
                            // TODO: handle error (SPIndicator)
                            SPIndicator.present(title: "Error😡",message: "Error when changing email", preset: .error, haptic: .error, from: .top)
                        } else {
                            // TODO: handle verify notification
                            SPIndicator.present(title: "Email update", preset: .done, haptic: .error, from: .top)
                        }
                    }
                }
            
                
                if password.count > 5 {
                    user.updatePassword(to: password)
                }
                
                changeProfireRequest.commitChanges { error in
                    // TODO: the same as 55-59 but in else block we sent notification, that all is goooood in any way dismiss
                    if let error {
                        SPIndicator.present(title: "Short password",message: "password must be greater that 5", preset: .error, haptic: .error, from: .top)
                    } else {
                        // TODO: handle error with the help of SPIndicator
                        // and dismiss
                        SPIndicator.present(title: "Password update", preset: .done, haptic: .error, from: .top)
                    }
                }
            }
                alertVC.addAction(yesAction)
                let noAction = UIAlertAction(title: "NO", style: .destructive) { _ in
                    self.dismiss(animated: true)
                }
                
                alertVC.addAction(noAction)
                self.present(alertVC, animated: true)
            }
            
        }
    }

