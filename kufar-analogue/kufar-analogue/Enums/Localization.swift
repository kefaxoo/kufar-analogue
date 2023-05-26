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
        case totalNumberOfRoomsLabel = "label.totalNumberOfRoomsLabel"
        
        case trashBtnLabel = "label.trash"
        case editBtnLabel = "label.edit"
    }
    
    enum ButtonText: String {
        case saveChangesText = "button.saveChangesButton"
        case editPost = "button.editPostButton"
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
        
        case UserDoesntExist = "indicator.UserDoesntExist"
        case UserDoesntHaveEmail = "indicator.UserDoesntHaveEmail"
        case WriteNamePost = "indicator.writeNamePost"
        case WritePhoneNumber = "indicator.writePhoneNumber"
        case WriteTotalNumberOfRooms = "indicator.writeTotalNumberOfRooms"
        case WriteNumbersOfFloors = "indicator.writeNumbersOfFloors"
        case WriteTotalArea = "indicator.writeTotalArea"
        case PleaseSelectBathroomType = "indicator.pleaseSelectBathroomType"
        case PleaseSelectBalconeType = "indicator.pleaseSelectBalconeType"
        case WritePrice = "indicator.writePrice"
        case errorDuringPhotoProcessing = "indicator.errorDuringPhotoProcessing"
        case postSuccessfulyCreated = "indicator.postSuccessfulyCreated"
        case postSuccessfulyEdited = "indicator.postSuccessfulyEdited"
    }
    enum AllertControllerTitle: String {
        case saveChangesAllertControllerTitle = "controller.saveChangesAllertControllerTitle"
        case thereIsNotDescription = "controller.thereIsNotDescription"
        case thereIsNoPhoto = "controller.thereIsNoPhoto"
    }
    enum AllertControllerMessage: String {
        case areYouSureToMakeChangesAllertControllerMessage = "controller.areYouSureToMakeChangesAllertControllerMessage"
        case doYouWantToCreatePostWithoutDescription = "controller.doYouWantToCreatePostWithoutDescription"
        case doYouWantToCreatePostWithoutPhoto = "controller.doYouWantToCreatePostWithoutPhoto"
    }
    enum ActionButton: String {
        case actionTitleYes = "action.yes"
        case actionTitleNo = "action.no"
        case actionDeletePost = "action.delete"
        
        case combinedBathroom = "action.combinedBathroom"
        case separateBathroom = "action.separateBathroom"
        case glazedBalcon = "action.glazedBalcon"
        case nonGlazedBalcon = "action.nonGlazedBalcon"
        
        case takePhoto = "action.takePhoto"
        case openGalerry = "action.openGalerry"
    }
    enum TextFieldPlaceholder: String {
        case textFieldTypeName = "placeholder.textFieldTypeName"
        case textFieldTypeEmail = "placeholder.textFieldTypeEmail"
        case textFieldTypePassword = "placeholder.textFieldTypePassword"
        case textFieldTypeAddress = "placeholder.textFieldTypeAddress"
    }
}

