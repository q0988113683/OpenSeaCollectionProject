//
//  ItemCollectionViewCell.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/16.
//

import UIKit
import Kingfisher

class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemImageView: UIImageView! {
        didSet {
            itemImageView.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(_ item: Asset) {
        setImageView(item)
        setNameLabel(item)
    }
    
    private func setImageView(_ item: Asset) {
        itemImageView.image = nil
        itemImageView.backgroundColor = .clear
        
        if let urlString = item.imageURL, let url = URL(string: urlString)  {
            if url.isSVGPath {
                itemImageView.setSVGImage(with: url)
            }else {
                itemImageView.kf.setImage(with: url)
            }
        }else {
            itemImageView.backgroundColor = .lightGray
        }
    }
    
    private func setNameLabel(_ item: Asset) {
        nameLabel.text = item.name
    }

}
