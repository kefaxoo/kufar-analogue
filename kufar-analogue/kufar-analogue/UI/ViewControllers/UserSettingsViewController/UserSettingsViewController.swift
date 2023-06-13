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

    @IBOutlet weak var userSettingNameLabel: UILabel!
    @IBOutlet weak var userSettingEmailLabel: UILabel!
    @IBOutlet weak var userSettingPasswordLabel: UILabel!
    
    @IBOutlet weak var saveChangesButton: UIButton!
    
    weak var delegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = Auth.auth().currentUser {
            if let name = user.displayName {
                nameTextField.text = name
            }
            
            guard let email = user.email else { return }
            
            emailTextField.text = email
            setupLocalization()
        } else {
            SPIndicator.present(title: Localization.Indicator.Title.plsLogin.rawValue.localized,message: Localization.Indicator.Message.LogInToChangeProfile.rawValue.localized, preset: .error, haptic: .error, from: .top)
             
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupLocalization() {
        userSettingNameLabel.text = Localization.Words.name.rawValue.localized
        userSettingEmailLabel.text = Localization.Words.email.rawValue.localized
        userSettingPasswordLabel.text = Localization.Words.password.rawValue.localized
        
        nameTextField.placeholder = Localization.TextField.Placeholder.typeSomething.rawValue.localizedWithParameter(text: Localization.Words.name.rawValue.localized)
        emailTextField.placeholder = Localization.TextField.Placeholder.typeSomething.rawValue.localizedWithParameter(text: Localization.Words.email.rawValue.localized)
        passwordTextField.placeholder = Localization.TextField.Placeholder.typeSomething.rawValue.localizedWithParameter(text: Localization.Words.password.rawValue.localized)
        saveChangesButton.setTitle(Localization.Button.Title.saveChanges.rawValue.localized, for: .normal)
    }
    
    @IBAction func saveChangesAction(_ sender: Any) {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text
                
        else { return }
        
        let alertVC = UIAlertController(title: Localization.Alert.Controller.Title.saveChanges.rawValue.localized, message: Localization.Alert.Controller.Message.areYouSureToMakeChanges.rawValue.localized, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: Localization.Alert.Action.yes.rawValue.localized, style: .default) { _ in
            if let user = Auth.auth().currentUser {
                let changeProfileRequest = user.createProfileChangeRequest()
                changeProfileRequest.displayName = name
                if let emailDb = user.email,
                   emailDb != email {
                    user.updateEmail(to: email) { error in
                        if let error {
                            SPIndicator.present(title: Localization.Indicator.Title.error.rawValue.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
                        } else {
                            SPIndicator.present(title: Localization.Indicator.Title.success.rawValue.localized, message: Localization.Indicator.Message.plsCheckUrEmailForConfirmNewEmail.rawValue.localized, preset: .done, haptic: .success, from: .top)
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
                if password.count > 5 {
                    user.updatePassword(to: password)
                } else {
                    SPIndicator.present(title: Localization.Indicator.Title.error.rawValue.localized, message: Localization.Indicator.Message.passwordHasLess.rawValue.localized, preset: .error, haptic: .error, from: .top)
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                
                changeProfileRequest.commitChanges { error in
                    if let error {
                        SPIndicator.present(title: Localization.Indicator.Title.error.rawValue.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
                    } else {
                        SPIndicator.present(title: Localization.Indicator.Title.success.rawValue.localized, message: Localization.Indicator.Message.plsCheckUrEmailForConfirmNewEmail.rawValue.localized, preset: .done, haptic: .success, from: .top)
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        alertVC.addAction(yesAction)
        let noAction = UIAlertAction(title: Localization.Alert.Action.no.rawValue.localized, style: .destructive) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertVC.addAction(noAction)
        self.present(alertVC, animated: true)
    }
}

