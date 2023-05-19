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
        } else {
            
            SPIndicator.present(title: Localization.IndicatorTitle.pleaseLogin.rawValue.localized,message: Localization.IndicatorMessage.LogInToChangeYourProfileIndicator.rawValue.localized, preset: .error, haptic: .error, from: .top)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupLocalization (){
        userSettingNameLabel.text = Localization.Label.userSettingNameLabel.rawValue.localized
        userSettingEmailLabel.text = Localization.Label.userSettingEmailLabel.rawValue.localized
        userSettingPasswordLabel.text = Localization.Label.userSettingPasswordLabel.rawValue.localized
        
        nameTextField.placeholder = Localization.TextFieldPlaceholder.textFieldTypeName.rawValue.localized
        emailTextField.placeholder = Localization.TextFieldPlaceholder.textFieldTypeEmail.rawValue.localized
        passwordTextField.placeholder = Localization.TextFieldPlaceholder.textFieldTypePassword.rawValue.localized
        //?
        saveChangesButton.setTitle(Localization.ButtonText.saveChangesText.rawValue.localized, for:.normal )
        //?
    }
    
    @IBAction func saveChangesAction(_ sender: Any) {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text
                
        else { return }
        
        let alertVC = UIAlertController(title: Localization.AllertControllerTitle.saveChangesAllertControllerTitle.rawValue.localized, message: Localization.AllertControllerMessage.areYouSureToMakeChangesAllertControllerMessage.rawValue.localized, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: Localization.ActionButton.actionTitleYes.rawValue.localized, style: .default) { _ in
            if let user = Auth.auth().currentUser {
                let changeProfileRequest = user.createProfileChangeRequest()
                changeProfileRequest.displayName = name
                if let emailDb = user.email,
                   emailDb != email {
                    user.updateEmail(to: email) { error in
                        if let error {
                            SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
                        } else {
                            SPIndicator.present(title: Localization.IndicatorTitle.successIndicator.rawValue.localized, message: Localization.IndicatorMessage.pleaseCheckYourEmailForConfirmNewEmailIndicator.rawValue.localized, preset: .done, haptic: .success, from: .top)
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
                if password.count > 5 {
                    user.updatePassword(to: password)
                } else {
                    SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: Localization.IndicatorMessage.passwordHasLessIndicator.rawValue.localized, preset: .error, haptic: .error, from: .top)
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                
                changeProfileRequest.commitChanges { error in
                    if let error {
                        SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
                    } else {
                        SPIndicator.present(title: Localization.IndicatorTitle.successIndicator.rawValue.localized, message: Localization.IndicatorMessage.pleaseCheckYourEmailForConfirmNewEmailIndicator.rawValue.localized, preset: .done, haptic: .success, from: .top)
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        alertVC.addAction(yesAction)
        let noAction = UIAlertAction(title: Localization.ActionButton.actionTitleNo.rawValue.localized, style: .destructive) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertVC.addAction(noAction)
        self.present(alertVC, animated: true)
    }
}

