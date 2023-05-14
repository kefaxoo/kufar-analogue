//
//  PostTableViewCell.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 14.05.23.
//

import UIKit
import FirebaseStorage
import SDWebImage

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var numberOfRoomsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    private(set) var post: PostModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(_ post: PostModel) {
        self.post = post
        if !post.imageUrl.isEmpty {
            let storageRef = Storage.storage().reference()
            let photoRef = storageRef.child(post.imageUrl)
            photoRef.downloadURL { url, error in
                if error != nil {
                    self.pictureImageView.image = UIImage(systemName: "xmark.circle")
                } else {
                    self.pictureImageView.sd_setImage(with: url)
                }
            }
        } else {
            pictureImageView.image = UIImage(systemName: "xmark.circle")
        }
        
        nameLabel.text = post.name
        areaLabel.text = "\(post.totalArea) m2"
        numberOfRoomsLabel.text = "\(post.totalNumberOfRooms) rooms"
        priceLabel.text = "\(post.price)k$"
    }
}
