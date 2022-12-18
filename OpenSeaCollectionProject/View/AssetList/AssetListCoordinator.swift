//
//  AssetListCoordinator.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//

import UIKit
import Combine

class AssetListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    internal var navigationController: UINavigationController  // 1
    private var subscriptions = Set<AnyCancellable>()
    
    var assetListViewController: AssetListViewController?
    
    // MARK: - Intialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showAssetListController()
    }

    // MARK: - Private methods
    private func showAssetListController() {
        let assetListViewController = AssetListViewController(nibName: nil, bundle: nil)
        assetListViewController.didSelectCell.sink { [weak self] item in
            guard let strongSelf = self else{ return }
            strongSelf.showAssetDetailViewController(with: item)
        }.store(in: &subscriptions)
        navigationController.show(assetListViewController, sender: self)
    }
    
    private func showAssetDetailViewController(with item: Asset) {
        let child = AssetDetailCoordinator(navigationController: navigationController, asset: item)
        child.finishFlow.sink { [weak self, weak child]  _ in
            if let strongSelf = self,  let strongChild = child {
                strongSelf.childDidFinish(strongChild)
            }
        }.store(in: &subscriptions)
        child.start()
        childCoordinators.append(child)
    }
    
    private func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
