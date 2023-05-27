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
    
    enum NavigationBar: String {
        case settings = "navigationBar.settings"
        case signOut = "navigationBar.signOut"
        case signIn = "navigationBar.signIn"
    }
    
    enum Label: String {
        case totalNumebrOfRooms = "label.totalNumberOfRooms"
    }
    
    enum Button {
        enum Menu {
            enum Action: String {
                case combinedBathroom = "button.menu.action.combinedBathroom"
                case separateBathroom = "button.menu.action.separatedBathroom"
                case glazedBalcon = "button.menu.action.glazedBalcon"
                case nonGlazedBalcon = "button.menu.action.nonGlazedBalcon"
                case takePhoto = "button.menu.action.takePhoto"
                case openGallery = "button.menu.action.openGallery"
            }
        }
        
        enum Title: String {
            case addPost = "button.title.addPost"
            case editPost = "button.title.editPost"
        }
    }
    
    enum Indicator {
        enum Title: String {
            case error = "indicator.title.error"
            case success = "indicator.title.success"
            case resetPasswordMessageWasSent = "indicator.title.resetPasswordMessageWasSent"
            
            var localized: String {
                return self.rawValue.localized
            }
        }
        
        enum Message: String {
            case userDoesntExist = "indicator.message.userDoesntExist"
            case userDoesntHaveEmail = "indicator.message.userDoesntHaveEmail"
            case nameIsEmpty = "indicator.message.nameIsEmpty"
            case phoneNumberIsEmpty = "indicator.message.phoneNumberIsEmpty"
            case totalNumberOfRoomsIsEmpty = "indicator.message.totalNumberOfRoomsIsEmpty"
            case numberOfFloorsIsEmpty = "indicator.message.numberOfFloorsIsEmpty"
            case floorIsEmpty = "indicator.message.floorsIsEmpty"
            case totalAreaIsEmpty = "indicator.message.totalAreaIsEmpty"
            case bathroomTypeIsntSelected = "indicator.message.bathroomTypeIsntSelected"
            case balconyTypeIsntSelected = "indicator.message.balconyTypeIsntSelected"
            case priceIsEmpty = "indicator.message.priceIsEmpty"
            case errorPhotoProcessing = "indicator.message.errorPhotoProcessing"
            case postCreatedSuccessfully = "indicator.message.postCreatedSuccessfully"
            case postEditedSuccessfully = "indicator.message.postEditedSuccessfully"
            case emailIsEmpty = "indicator.message.emailIsEmpty"
            case passwordIsEmpty = "indicator.message.passwordIsEmpty"
            case verifyEmail = "indicator.message.verifyEmail"
        }
    }
    
    enum Alert {
        enum Controller {
            enum Title: String {
                case descriptionIsEmpty = "alert.controller.title.descriptionIsEmpty"
                case photoIsEmpty = "alert.controller.title.photoIsEmpty"
            }
            
            enum Message: String {
                case createPostWithoutDescription = "alert.controller.message.createPostWithoutDescription"
                case createPostWithoutPhoto = "alert.contoller.message.createPostWithoutPhoto"
            }
        }
        
        enum Action: String {
            case yes = "alert.action.yes"
            case no = "alert.action.no"
        }
    }
    
    enum ActionButton: String {
        case combinedBathroom = "action.combinedBathroom"
        case separateBathroom = "action.separateBathroom"
        case glazedBalcon = "action.glazedBalcon"
        case nonGlazedBalcon = "action.nonGlazedBalcon"
        
        case takePhoto = "action.takePhoto"
        case openGalerry = "action.openGalerry"
    }
    
    enum TextField {
        enum Placeholder: String {
            case typeSomething = "textField.placeholder.typeSomething"
        }
    }
    
    enum Words: String {
        case name = "words.name"
        case password = "words.password"
    }
}

