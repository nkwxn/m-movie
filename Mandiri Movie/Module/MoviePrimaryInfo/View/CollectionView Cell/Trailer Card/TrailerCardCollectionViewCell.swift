//
//  TrailerCardCollectionViewCell.swift
//  Mandiri Movie
//
//  Created by Nicholas on 14/04/22.
//

import UIKit
import Alamofire
import WebKit

class TrailerCardCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrailerCardCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var vidPlayerWebView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.cornerRadius = 18
        vidPlayerWebView.scrollView.isScrollEnabled = false
    }
    
    func setupView(with video: Video) {
        self.titleLabel.text = video.name
        
        guard let youtubeURL = URL(string: URLConstants.generateYoutubeURL(with: video.key ?? "")) else { return }
        vidPlayerWebView.load(URLRequest(url: youtubeURL))
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
