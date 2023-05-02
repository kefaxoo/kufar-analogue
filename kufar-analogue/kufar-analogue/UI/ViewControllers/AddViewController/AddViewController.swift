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
    
    private var photo: UIImage?
    private var bathroomType = "combined"
    private var balconyType = "glazed"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    private func setupInterface() {
        photoView.layer.borderColor = UIColor.label.withAlphaComponent(0.3).cgColor
        photoView.layer.borderWidth = 2
        photoView.layer.cornerRadius = 8
        
        let combinedAction = UIAction(title: "Combined bathroom") { _ in
            self.bathroomType = "combined"
        }
        
        let separateAction = UIAction(title: "Separate bathroom") { _ in
            self.bathroomType = "separate"
        }
        
        bathroomTypePopUpButton.menu = UIMenu(options: .displayInline, children: [combinedAction, separateAction])
        
        let glazedAction = UIAction(title: "Glazed balcony") { _ in
            self.balconyType = "glazed"
        }
        
        let nonGlazedAction = UIAction(title: "Non-glazed balcony") { _ in
            self.balconyType = "non-glazed"
        }
        
        balconyTypePopUpButton.menu = UIMenu(options: .displayInline, children: [glazedAction, nonGlazedAction])
        
        descriptionTextView.isEditable = true
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.layer.borderColor = UIColor.label.withAlphaComponent(0.3).cgColor
        descriptionTextView.layer.cornerRadius = 8
    }
    
    @IBAction func addPhotoAction(_ sender: Any) {
        let takePhotoAction = UIAction(title: "Take photo") { _ in
            print("Take photo")
            let imagePickerVC = UIImagePickerController()
            imagePickerVC.sourceType = .camera
            imagePickerVC.delegate = self
            self.present(imagePickerVC, animated: true)
        }
        
        let openGalleryAction = UIAction(title: "Open gallery") { _ in
            print("Open gallery")
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
            SPIndicator.present(title: "Error", message: "User doesn't exist", preset: .error, haptic: .error , from: .top)
            return
        }
        
        guard let email = user.email else {
            SPIndicator.present(title: "Error", message: "User doesn't have email", preset: .error, haptic: .error , from: .top)
            return
        }
        
        guard let name = nameTextField.text else {
            SPIndicator.present(title: "Error", message: "Write name post", preset: .error, haptic: .error , from: .top)
            return
        }
        
        guard let phoneNumber = phoneTextField.text else {
            SPIndicator.present(title: "Error", message: "Write phone number", preset: .error, haptic: .error , from: .top)
            return
        }
        
        guard let totalNumberOfRoomsStr = totalNumberOfRoomsTextField.text,
              let totalNumberOfRooms = Int(totalNumberOfRoomsStr)
        else {
            // MARK: -
            // TODO: Display indicator
            return
        }
        
        guard let numberOfFloorsStr = numberOfFloorsTextField.text,
              let numberOfFloors = Int(numberOfFloorsStr),
              numberOfFloors > 1,
              numberOfFloors < 30
        else {
            // MARK: -
            // TODO: Display indicator
            return
        }
        
        guard let floorStr = floorTextField.text,
              let floor = Int(floorStr),
              floor <= numberOfFloors,
              floor > 1,
              floor < 30
        else {
            // MARK: -
            // TODO: Display indicator
            return
        }
        
        guard let totalAreaStr = totalAreaTextField.text,
              let totalArea = Double(totalAreaStr),
              totalArea > 1
        else {
            // MARK: -
            // TODO: Display indicator
            return
        }
        
        if bathroomType.isEmpty {
            // MARK: -
            // TODO: Display indicator
            return
        }
        
        if balconyType.isEmpty {
            // MARK: -
            // TODO: Display indicator
            return
        }
        
        guard let priceStr = priceTextField.text,
              let price = Int(priceStr),
              price > 1
        else {
            // MARK: -
            // TODO: Display indicator
            return
        }
        
        if let description = descriptionTextView.text,
           !description.isEmpty {
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
        } else {
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
                SPIndicator.present(title: "Error", message: "Error during photo processing", preset: .error, haptic: .error, from: .top)
                return
            }
            
            let uploadTask = photoRef.putData(photoData) { _, error in
                if let error {
                    SPIndicator.present(title: "Error", message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
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
                SPIndicator.present(title: "Error", message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
            } else {
                SPIndicator.present(title: "Success", message: "Post successfully created", preset: .done, haptic: .success, from: .top)
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
    }
}
