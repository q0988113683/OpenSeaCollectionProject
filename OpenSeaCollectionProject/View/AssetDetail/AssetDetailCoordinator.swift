//
//  AssetDetailCoordinator.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/15.
//

import UIKit
import Combine

class AssetDetailCoordinator: Coordinator {
    
    internal var navigationController: UINavigationController  // 1
    
    var finishFlow = PassthroughSubject<Void,Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var item: Asset
    
    // MARK: - Intialization
    init(navigationController: UINavigationController, asset: Asset) {
        self.navigationController = navigationController
        self.item = asset
    }
    
    func start() {
        let assetDetailViewController = AssetDetailViewController(with: .init(assets: item))
        assetDetailViewController.viewDidDisappear.sink { [weak self] _ in
            guard let strongSelf = self else{ return }
            strongSelf.finishFlow.send()
        }.store(in: &subscriptions)
        navigationController.pushViewController(assetDetailViewController, animated: true)
    }
    
    deinit{
        print("deinit")
    }
    
}
