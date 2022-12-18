//
//  Coordinator.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}


//warning project: Usage of /Users/jhuoyucheng/Library/org.swift.swiftpm/collections.json has been deprecated. Please delete it and use the new /Users/jhuoyucheng/Library/org.swift.swiftpm/configuration/collections.json instead.
