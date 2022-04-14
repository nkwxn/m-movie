//
//  TextImageCollectionViewCell.swift
//  Mandiri Movie
//
//  Created by Nicholas on 14/04/22.
//

import UIKit
import Alamofire

class TextImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "TextImageCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.cornerRadius = 18
    }

    func setImage(from url: String) {
        AF.request(url, method: .get).response { [weak self] response in
            if let data = response.data {
                let image = UIImage(data: data)
                self?.imageView.image = image
            } else {
                self?.imageView.image = UIImage(systemName: "rectangle.badge.xmark")
                self?.labelView.numberOfLines = 0
            }
//            self?.imageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
