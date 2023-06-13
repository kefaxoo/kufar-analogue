import Foundation
import UIKit
import SDWebImage
import FirebaseStorage

class InformationViewController: UIViewController {
    
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.tintColor = UIColor.systemGreen
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        if let font = UIFont(name: "Helvetica Neue", size: 24){
            label.font = font
        }
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        if let font = UIFont(name: "Helvetica Neue", size: 16){
            label.font = font
        }
        label.textColor = UIColor.systemGreen
        return label
    }()
    
    lazy var descriptionScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(coverImageView)
        view.addSubview(addressLabel)
        view.addSubview(priceLabel)
        view.addSubview(descriptionScrollView)
        descriptionScrollView.addSubview(descriptionLabel)
        
        if let post = post {
            setupInterface(post)
        }
        
        let constraints = [
            coverImageView.topAnchor.constraint(equalTo: view.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
            
            addressLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                        
            priceLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                        
            descriptionScrollView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            descriptionScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                        
            descriptionLabel.topAnchor.constraint(equalTo: descriptionScrollView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionScrollView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionScrollView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionScrollView.bottomAnchor)
        ]
      
        NSLayoutConstraint.activate(constraints)
    }
    
    private var post: PostModel?

    private func set(post: PostModel) {
    self.post = post
    }
    
    private func setupInterface(_ post: PostModel) {
        
        if !post.imageUrl.isEmpty {
            let storageRef = Storage.storage().reference()
            let photoRef = storageRef.child(post.imageUrl)
            photoRef.downloadURL { url, error in
                if error != nil {
                    self.coverImageView.image = UIImage(systemName: "xmark.circle")
                } else {
                    self.coverImageView.sd_setImage(with: url)
                }
            }
        } else {
            coverImageView.image = UIImage(systemName: "xmark.circle")
        }
        
        addressLabel.text = post.name
        priceLabel.text = "\(post.price)"
        descriptionLabel.text = post.description
    }
}
