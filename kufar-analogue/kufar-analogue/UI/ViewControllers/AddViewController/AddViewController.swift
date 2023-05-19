//
//  AddViewController.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 18.04.23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SPIndicator

class AddViewController: UIViewController {
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var totalNumberOfRoomsStepper: UIStepper!
    @IBOutlet weak var totalNumberOfRoomsTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var numberOfFloorsTextField: UITextField!
    @IBOutlet weak var totalAreaTextField: UITextField!
    @IBOutlet weak var bathroomTypePopUpButton: UIButton!
    @IBOutlet weak var balconyTypePopUpButton: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var totalNumberOfRoomsLabel: UILabel!
    
    private var photo: UIImage?
    private var bathroomType = "combined"
    private var balconyType = "glazed"
    private var post: PostModel?
    private var type: PostControllerType = .add
    private var isPhotoEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func set(_ post: PostModel) {
        self.post = post
        self.type = .edit
    }
    
    private func setupLocalization() {
        nameTextField.placeholder = "" // Localization.AddVC.Placeholders.name.rawValue.localizable
        totalNumberOfRoomsLabel.text = "" // Localization...
    }
    
    private func setupInterface() {
        photoView.layer.borderColor = UIColor.label.withAlphaComponent(0.3).cgColor
        photoView.layer.borderWidth = 2
        photoView.layer.cornerRadius = 8
        
        if type == .edit {
            nameTextField.isEnabled = false
        }
        
        // MARK: -
        let combinedAction = UIAction(title: "Combined bathroom") { _ in
            self.bathroomType = "combined"
        }
        
        let separateAction = UIAction(title: "Separate bathroom") { _ in
            self.bathroomType = "separate"
        }
        
        if self.type == .edit {
            guard let post,
                  let bathroomType = BathroomType(rawValue: post.bathroomType)
            else { return }
            
            switch bathroomType {
                case .separate:
                    separateAction.state = .on
                case .combined:
                    combinedAction.state = .on
            }
        }
        
        bathroomTypePopUpButton.menu = UIMenu(options: .displayInline, children: [combinedAction, separateAction])
        
        let glazedAction = UIAction(title: "Glazed balcony") { _ in
            self.balconyType = "glazed"
        }
        
        let nonGlazedAction = UIAction(title: "Non-glazed balcony") { _ in
            self.balconyType = "non-glazed"
        }
        
        if self.type == .edit {
            guard let post,
                  let balconyType = BalconyType(rawValue: post.balconyType)
            else { return }
            
            switch balconyType {
                case .glazed:
                    glazedAction.state = .on
                case .nonGlazed:
                    nonGlazedAction.state = .on
            }
        }
        
        balconyTypePopUpButton.menu = UIMenu(options: .displayInline, children: [glazedAction, nonGlazedAction])
        
        descriptionTextView.isEditable = true
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.layer.borderColor = UIColor.label.withAlphaComponent(0.3).cgColor
        descriptionTextView.layer.cornerRadius = 8
        
        if self.type == .edit {
            guard let post else { return }
            
            self.navigationController?.navigationBar.prefersLargeTitles = false
            if !post.imageUrl.isEmpty {
                let storageRef = Storage.storage().reference()
                let photoRef = storageRef.child(post.imageUrl)
                photoRef.downloadURL { url, error in
                    if error != nil {
                        self.photoImageView.image = UIImage(systemName: "xmark.circle")
                    } else {
                        self.photoImageView.sd_setImage(with: url) { image, error, _, _ in
                            self.photo = image
                        }
                    }
                }
            }
            
            nameTextField.text = post.name
            phoneTextField.text = post.phoneNumber
            totalNumberOfRoomsTextField.text = "\(post.totalNumberOfRooms)"
            floorTextField.text = "\(post.floor)"
            numberOfFloorsTextField.text = "\(post.numberOfFloors)"
            totalAreaTextField.text = "\(post.totalArea)"
            bathroomTypePopUpButton.setTitle(BathroomType(rawValue: post.bathroomType)!.title, for: .normal)
            balconyTypePopUpButton.setTitle(BalconyType(rawValue: post.balconyType)!.title, for: .normal)
            priceTextField.text = "\(post.price)"
            descriptionTextView.text = post.description
            // MARK: -
            addButton.setTitle("Edit post", for: .normal)
        }
    }
    
    @IBAction func addPhotoAction(_ sender: Any) {
        let takePhotoAction = UIAction(title: "Take photo") { _ in
            let imagePickerVC = UIImagePickerController()
            imagePickerVC.sourceType = .camera
            imagePickerVC.delegate = self
            self.present(imagePickerVC, animated: true)
        }
        
        let openGalleryAction = UIAction(title: "Open gallery") { _ in
            let imagePickerVC = UIImagePickerController()
            imagePickerVC.sourceType = .savedPhotosAlbum
            imagePickerVC.delegate = self
            self.present(imagePickerVC, animated: true)
        }
        
        addPhotoButton.showsMenuAsPrimaryAction = true
        addPhotoButton.menu = UIMenu(children: [takePhotoAction, openGalleryAction])
    }
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        totalNumberOfRoomsTextField.text = "\(Int(totalNumberOfRoomsStepper.value))"
    }
    
    @IBAction func addPostAction(_ sender: Any) {
        guard let user = Auth.auth().currentUser else {
            SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: "User doesn't exist", preset: .error, haptic: .error , from: .top)
            return
        }
        
        guard let email = user.email else {
            SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: "User doesn't have email", preset: .error, haptic: .error , from: .top)
            return
        }
        
        guard let name = nameTextField.text else {
            SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: "Write name post", preset: .error, haptic: .error , from: .top)
            return
        }
        
        guard let phoneNumber = phoneTextField.text else {
            SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: "Write phone number", preset: .error, haptic: .error , from: .top)
            return
        }
        
        guard let totalNumberOfRoomsStr = totalNumberOfRoomsTextField.text,
              let totalNumberOfRooms = Int(totalNumberOfRoomsStr)
        else {
            SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: "Write total number of Rooms💅", preset: .error, haptic: .error , from: .top)
            return
        }
        
        guard let numberOfFloorsStr = numberOfFloorsTextField.text,
              let numberOfFloors = Int(numberOfFloorsStr),
              numberOfFloors > 1,
              numberOfFloors < 30
        else {
            SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: "Write number of floors (1-30)💅", preset: .error, haptic: .error , from: .top)
            return
        }
        
        guard let floorStr = floorTextField.text,
              let floor = Int(floorStr),
              floor <= numberOfFloors,
              floor > 1,
              floor < 30
        else {
            SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: "Write floor (1-30)💅", preset: .error, haptic: .error , from: .top)
            return
        }
        
        guard let totalAreaStr = totalAreaTextField.text,
              let totalArea = Double(totalAreaStr),
              totalArea > 1
        else {
            SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: "Write total area💅", preset: .error, haptic: .error , from: .top)
            return
        }
        
        if bathroomType.isEmpty {
            SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: "Please, select bathroom type💅", preset: .error, haptic: .error , from: .top)
            return
        }
        
        if balconyType.isEmpty {
            SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: "Please, select balcony type💅", preset: .error, haptic: .error , from: .top)
            return
        }
        
        guard let priceStr = priceTextField.text,
              let price = Int(priceStr),
              price > 1
        else {
            SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: "Please, write price💅", preset: .error, haptic: .error , from: .top)
            return
        }
        
        if let description = descriptionTextView.text,
           !description.isEmpty {
            if type == .add {
                if photo != nil {
                    uploadPhoto(email: email, name: name) { imageUrl in
                        self.addPost(
                            email: email,
                            description: description,
                            floor: floor,
                            imageUrl: imageUrl,
                            name: name,
                            numberOfFloors: numberOfFloors,
                            phoneNumber: phoneNumber,
                            price: price,
                            totalArea: totalArea,
                            totalNumberOfRooms: totalNumberOfRooms
                        )
                    }
                } else {
                    addPostWithoutPhoto {
                        self.addPost(
                            email: email,
                            description: description,
                            floor: floor,
                            name: name,
                            numberOfFloors: numberOfFloors,
                            phoneNumber: phoneNumber,
                            price: price,
                            totalArea: totalArea,
                            totalNumberOfRooms: totalNumberOfRooms
                        )
                    }
                }
            } else if type == .edit {
                guard let post else { return }
                
                if !isPhotoEdit {
                    self.updatePost(email: email, description: description, floor: floor, imageUrl: post.imageUrl, name: name, numberOfFloors: numberOfFloors, phoneNumber: phoneNumber, price: price, totalArea: totalArea, totalNumberOfRooms: totalNumberOfRooms)
                } else {
                    uploadPhoto(email: email, name: name) { imageUrl in
                        self.updatePost(email: email, description: description, floor: floor, imageUrl: imageUrl, name: name, numberOfFloors: numberOfFloors, phoneNumber: phoneNumber, price: price, totalArea: totalArea, totalNumberOfRooms: totalNumberOfRooms)
                    }
                }
            }
        } else {
            if type == .add {
                if photo != nil {
                    addPostWithoutDescription {
                        self.uploadPhoto(email: email, name: name) { imageUrl in
                            self.addPost(
                                email: email,
                                floor: floor,
                                imageUrl: imageUrl,
                                name: name,
                                numberOfFloors: numberOfFloors,
                                phoneNumber: phoneNumber,
                                price: price,
                                totalArea: totalArea,
                                totalNumberOfRooms: totalNumberOfRooms
                            )
                        }
                    }
                } else {
                    addPostWithoutPhoto {
                        self.addPostWithoutDescription {
                            self.addPost(
                                email: email,
                                floor: floor,
                                name: name,
                                numberOfFloors: numberOfFloors,
                                phoneNumber: phoneNumber,
                                price: price,
                                totalArea: totalArea,
                                totalNumberOfRooms: totalNumberOfRooms
                            )
                        }
                    }
                }
            } else if type == .edit {
                guard let post else { return }
                
                addPostWithoutDescription {
                    if !self.isPhotoEdit {
                        self.updatePost(email: email, floor: floor, imageUrl: post.imageUrl, name: name, numberOfFloors: numberOfFloors, phoneNumber: phoneNumber, price: price, totalArea: totalArea, totalNumberOfRooms: totalNumberOfRooms)
                    } else {
                        self.uploadPhoto(email: email, name: name) { imageUrl in
                            self.updatePost(email: email, floor: floor, imageUrl: imageUrl, name: name, numberOfFloors: numberOfFloors, phoneNumber: phoneNumber, price: price, totalArea: totalArea, totalNumberOfRooms: totalNumberOfRooms)
                        }
                    }
                }
            }
        }
    }
    
    private func addPostWithoutDescription(closure: @escaping (() -> ())) {
        let alertVC = UIAlertController(title: "There is no description", message: "Do you want to create post without description?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            closure()
        }
        let noAction = UIAlertAction(title: "No", style: .destructive)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        self.present(alertVC, animated: true)
    }
    
    private func addPostWithoutPhoto(closure: @escaping (() -> ())) {
        let alertVC = UIAlertController(title: "There is no photo", message: "Do you want to create post without photo?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            closure()
        }
        let noAction = UIAlertAction(title: "No", style: .destructive)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        self.present(alertVC, animated: true)
    }
    
    private func uploadPhoto(email: String, name: String, closure: @escaping ((String) -> ())) {
        if let photo {
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let path = "images/\(email)-\(name.toUnixFilename).png"
            let photoRef = storageRef.child(path)
            guard let photoData = photo.pngData() else {
                SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: "Error during photo processing", preset: .error, haptic: .error, from: .top)
                return
            }
            
            photoRef.putData(photoData) { _, error in
                if let error {
                    SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
                } else {
                    closure(path)
                }
            }
        }
    }
    
    private func addPost(email: String, description: String = "", floor: Int, imageUrl: String = "", name: String, numberOfFloors: Int, phoneNumber: String, price: Int, totalArea: Double, totalNumberOfRooms: Int) {
        let db = Firestore.firestore()
        let id = "\(email)-\(name.toUnixFilename)"
        db.collection("posts").document(id).setData([
            "balconyType": self.balconyType,
            "bathroomType": self.bathroomType,
            "creatorEmail": email,
            "description": description,
            "floor": floor,
            "imageUrl": imageUrl,
            "name": name,
            "numberOfFloors": numberOfFloors,
            "phoneNumber": phoneNumber,
            "price": price,
            "totalArea": totalArea,
            "totalNumberOfRooms": totalNumberOfRooms
        ]) { error in
            if let error {
                SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
            } else {
                SPIndicator.present(title: Localization.IndicatorTitle.successIndicator.rawValue.localized, message: "Post successfully created", preset: .done, haptic: .success, from: .top)
            }
        }
    }
    
    private func updatePost(email: String, description: String = "", floor: Int, imageUrl: String = "", name: String, numberOfFloors: Int, phoneNumber: String, price: Int, totalArea: Double, totalNumberOfRooms: Int) {
        let db = Firestore.firestore()
        let id = "\(email)-\(name.toUnixFilename)"
        db.collection("posts").document(id).updateData([
            "balconyType": self.balconyType,
            "bathroomType": self.bathroomType,
            "creatorEmail": email,
            "description": description,
            "floor": floor,
            "imageUrl": imageUrl,
            "numberOfFloors": numberOfFloors,
            "phoneNumber": phoneNumber,
            "price": price,
            "totalArea": totalArea,
            "totalNumberOfRooms": totalNumberOfRooms
        ]) { error in
            if let error {
                SPIndicator.present(title: Localization.IndicatorTitle.errorIndicator.rawValue.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
            } else {
                SPIndicator.present(title: Localization.IndicatorTitle.successIndicator.rawValue.localized, message: "Post successfully edited", preset: .done, haptic: .success, from: .top)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension AddViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }

        self.photo = image
        self.photoImageView.image = image
        self.isPhotoEdit = true
    }
}
