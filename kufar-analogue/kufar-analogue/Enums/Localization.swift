//
//  Localization.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 17.05.23.
//

import Foundation

enum Localization {
    enum TabBar: String {
        case profile = "tabBar.profile"
        case add = "tabBar.add"
    }
    enum NavBar: String {
        case setting = "navBar.setting"
        case signOut = "navBar.signOut"
        case signIn = "navBar.signIn"
    }
    enum Label: String {
        case userSetting = "label.userSetting"
        case userSettingNameLabel = "label.userSettingNameLabel"
        case userSettingEmailLabel = "label.userSettingEmailLabel"
        case userSettingPasswordLabel = "label.userSettingPasswordLabel"
        case noPostLabel = "label.noPostLabel"
        case emptyProfileLabel = "label.emptyProfileLabel"
        
    }
    
    enum ButtonText: String {
        case saveChangesText = "button.saveChangesButton"
    }
    enum IndicatorTitle: String {
        case pleaseLogin = "indicator.pleaseLogin"
        case errorIndicator = "indicator.errorIndicator"
        case successIndicator = "indicator.successIndicator"
        case successDeletePostIndicator = "indicator.successDeletePostIndicator"
        case errorDeletePostIndicator = "indicator.errorDeletePostIndicator"
        case emailIsEmptyIndicator = "indicator.emailIsEmptyIndicator"
        case passwordResetEmailSentIndicator = "indicator.passwordResetEmailSentIndicator"
        case passwordIsEmptyIndicator = "indicator.passwordIsEmptyIndicator"
        case errorSigningInIndicator = "indicator.errorSigningInIndicator"
        case verifyEmailIndicator = "indicator.verifyEmailIndicator"
        case errorCreatingUserIndicator = "indicator.errorCreatingUserIndicator"
        case errorSendingVerificationEmailIndicator = "indicator.errorSendingVerificationEmailIndicator"
        case verificationEmailSentIndicator = "indicator.verificationEmailSentIndicator"
        
    }
    enum IndicatorMessage: String {
        case pleaseCheckYourEmailForConfirmNewEmailIndicator = "indicator.pleaseCheckYourEmailForConfirmNewEmailIndicator"
        case pleaseCheckYourEmailForVerifyEmailIndicator = "indicator.pleaseCheckYourEmailForVerufyNewEmailIndicator"
        case passwordHasLessIndicator = "indicator.passwordHasLessIndicator"
        case LogInToChangeYourProfileIndicator = "indicator.LogInToChangeYourProfileIndicator"
    }
    enum AllertControllerTitle: String {
        case saveChangesAllertControllerTitle = "controller.saveChangesAllertControllerTitle"
    }
    enum AllertControllerMessage: String {
        case areYouSureToMakeChangesAllertControllerMessage = "controller.areYouSureToMakeChangesAllertControllerMessage"
    }
    enum ActionButton: String {
        case actionTitleYes = "action.yes"
        case actionTitleNo = "action.no"
        case actionDeletePost = "action.delete"
    }
    enum TextFieldPlaceholder: String {
        case textFieldTypeName = "placeholder.textFieldTypeName"
        case textFieldTypeEmail = "placeholder.textFieldTypeEmail"
        case textFieldTypePassword = "placeholder.textFieldTypePassword"
    }
}

