//
//  MovieReviewCollectionViewCell.swift
//  Mandiri Movie
//
//  Created by Nicholas on 14/04/22.
//

import UIKit
import Alamofire

class MovieReviewCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieReviewCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    @IBOutlet weak var roundedCardView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.roundedCardView.layer.cornerRadius = 18
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.width / 2
    }

    func setupContent(with review: Review) {
        // Set image
        if var avatarPath = review.author_details?.avatar_path {
            avatarPath.removeFirst()
            AF.request(avatarPath, method: .get).response { [weak self] response in
                if let data = response.data {
                    let image = UIImage(data: data)
                    self?.avatarImageView.image = image
                }
            }
        }
        
        
        self.authorNameLabel.text = review.author
        if review.author != review.author_details?.username {
            self.usernameLabel.isHidden = false
            self.usernameLabel.text = review.author_details?.username
        }
        self.contentLabel.text = review.content
        self.createdDateLabel.text = "\(review.getFormattedDateCategory())"
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
