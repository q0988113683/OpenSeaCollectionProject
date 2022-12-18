//
//  UICollectionView+.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/16.
//

import Foundation
import UIKit

protocol NibProvidable: AnyObject {
    static func nib(bundle: Bundle?) -> UINib
}

protocol NibNameProvidable: AnyObject {
    static var nibName: String { get }
}

protocol NibProvidableFromClassName: NibProvidable, NibNameProvidable {
    
}

extension NibProvidableFromClassName {
    
    static var nibName: String {
        return String(describing: self)
    }
    
    static func nib(bundle: Bundle? = .main) -> UINib {
        return UINib(nibName: nibName, bundle: bundle)
    }
}


protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable where Self: NibProvidableFromClassName {
    static var reuseIdentifier: String {
        return nibName
    }
}

protocol NibRegisterable: Reusable, NibProvidableFromClassName {

}

extension UICollectionView {
    
    func register<T>(nibCell cell: T.Type, bundle: Bundle? = .main) where T: NibRegisterable {
        
        register(cell.nib(bundle: bundle), forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
    
    func register<T>(nibSupplementaryView supplementaryView: T.Type, kind: String, bundle: Bundle? = .main) where T: NibRegisterable {
        register(supplementaryView.nib(bundle: bundle), forSupplementaryViewOfKind: kind, withReuseIdentifier: supplementaryView.reuseIdentifier)
    }
    
    func reusableCell<T>(for indexPath: IndexPath) -> T where T: Reusable {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func reusableSupplementaryView<T>(ofKind kind: String, for indexPath: IndexPath) -> T where T: Reusable {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

extension UICollectionReusableView: NibRegisterable {
    
}
