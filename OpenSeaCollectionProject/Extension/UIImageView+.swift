//
//  UIImageView+.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/17.
//

import Foundation
import Kingfisher
import PocketSVG

extension UIImageView {
    
    func setSVGImage(with url: URL) {
        let processor = SVGProcessor(size: CGSize(width: 100, height: 100))
        KingfisherManager.shared.retrieveImage(with: url, options: [.processor(processor)]) { [weak self] result in
            switch (result){
            case .success(let value):
                guard let strongSelf = self else{ return }
                strongSelf.image = value.image
            case .failure(let error):
                print("error", error.localizedDescription)
            }
        }
    }
}
