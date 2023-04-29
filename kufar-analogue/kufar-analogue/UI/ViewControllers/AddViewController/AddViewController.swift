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
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    private var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.layer.borderColor = UIColor.label.withAlphaComponent(0.3).cgColor
        photoView.layer.borderWidth = 2
        photoView.layer.cornerRadius = 8
        saveButton.tintColor = UIColor.systemPurple
        descriptionTextView.isEditable = true
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.layer.borderColor = UIColor.label.withAlphaComponent(0.3).cgColor
        descriptionTextView.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveButton.tintColor = UIColor.systemPurple
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
    
    @IBAction func addPostAction(_ sender: Any) {
        guard let user = Auth.auth().currentUser else {
            // TODO: Display indicator when user not exist
            return
        }
        
        var id = ""
        guard let email = user.email else {
            // TODO: Display indicator
            return
        }
        
        id = email
        guard let name = nameTextField.text else {
            // TODO: Display indicator (название объявления)
            return
        }
        
        guard let phoneNumber = phoneTextField.text else {
            // TODO: Display indicator
            return
        }
        
        var description = ""
        if var descriptionText = descriptionTextView.text {
            description = descriptionText
        } else {
            let alertVC = UIAlertController(title: "Description is empty", message: "Do you want to create post without description?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                if let photo = self.photo {
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    let photoRef = storageRef.child("images/\(name).png")
                    guard let photoData = photo.pngData() else {
                        // TODO: Display indicator
                        return
                    }
                    
                    let uploadTask = photoRef.putData(photoData) { metadata, error in
                        if error != nil {
                            // TODO: Display indicator
                        } else {
                            self.addPost(email: email, description: description, name: name, phoneNumber: phoneNumber)
                        }
                    }
                } else {
                    let alertVC = UIAlertController(title: "There is no photo", message: "Do you want to create post without photo?", preferredStyle: .alert)
                    
                    let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                        self.addPost(email: email, description: description, name: name, phoneNumber: phoneNumber, isPhotoUploaded: false)
                    }
                    
                    let noAction = UIAlertAction(title: "No", style: .cancel)
                    alertVC.addAction(yesAction)
                    alertVC.addAction(noAction)
                    self.present(alertVC, animated: true)
                }
            }
            let noAction = UIAlertAction(title: "No", style: .cancel)
            
            alertVC.addAction(yesAction)
            alertVC.addAction(noAction)
            present(alertVC, animated: true)
        }
    }
    
    private func addPost(email: String, description: String, name: String, phoneNumber: String, isPhotoUploaded: Bool = true) {
        let db = Firestore.firestore()
        let id = isPhotoUploaded ? "\(email)-\(name).png".toUnixFilename : ""
        db.collection("posts").document(id).setData([
            "creatorEmail": email,
            "description": description,
            "imageUrl": "images/\(id).png",
            "name": name,
            "phoneNumber": phoneNumber
        ]) { error in
            if error != nil {
                // TODO: Display error indicator
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
