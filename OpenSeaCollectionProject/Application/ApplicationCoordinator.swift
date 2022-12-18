//
//  ApplicationCoordinator.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//
import UIKit

class ApplicationCoordinator: Coordinator {
    var navigationController: UINavigationController

    let window: UIWindow
    let assetListCoordinator: AssetListCoordinator
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        assetListCoordinator = AssetListCoordinator(navigationController: navigationController)
    }
    
    func start() {  // 6
        window.rootViewController = navigationController
        assetListCoordinator.start()
        window.makeKeyAndVisible()
    }
}
