//
//  MovieCollectionViewCell.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import UIKit
import Alamofire
import AlamofireImage

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
        self.imageView.contentMode = .scaleAspectFill
    }

    func setValue(with item: Movie) {
        movieTitleLabel.text = item.title
        
        AF.request(URLConstants.getImageURL(by: item.poster_path)).response { [weak self] response in
            if let data = response.data {
                let imgData = UIImage(data: data)
                self?.imageView.image = imgData
            } else {
                self?.imageView.image = UIImage(systemName: "rectangle.badge.xmark")
            }
        }
    }
}
