//
//  UserSettingsViewController.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 14.04.23.
//

import UIKit
import FirebaseAuth

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
        }
    }
    
    @IBAction func saveChangesAction(_ sender: Any) {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        
        let alertVC = UIAlertController(title: "Save changes?", message: "Are you sure to make changes?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "ХЛЭБ", style: .default) { _ in
            if var user = Auth.auth().currentUser {
                let changeProfireRequest = user.createProfileChangeRequest()
                changeProfireRequest.displayName = name
                if let emailDB = user.email,
                   emailDB != email {
                    user.updateEmail(to: email) { error in
                        if let error {
                            // TODO: handle error (SPIndicator)
                        } else {
                            // TODO: handle verify notification
                        }
                    }
                }
                
                if password.count > 5 {
                    user.updatePassword(to: password)
                }
                
                changeProfireRequest.commitChanges { error in
                    // TODO: the same as 55-59 but in else block we sent notification, that all is goooood in any way dismiss
                }
            } else {
                // TODO: handle error with the help of SPIndicator
                // and dismiss
            }
        }
        
        alertVC.addAction(yesAction)
        let noAction = UIAlertAction(title: "МАТЧА", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        
        alertVC.addAction(noAction)
        self.present(alertVC, animated: true)
    }
}
