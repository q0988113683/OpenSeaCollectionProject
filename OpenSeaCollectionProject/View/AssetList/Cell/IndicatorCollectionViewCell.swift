//
//  IndicatorCollectionViewCell.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/17.
//

import UIKit

class IndicatorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var inidicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func startAnimating() {
        inidicatorView.startAnimating()
    }
}
