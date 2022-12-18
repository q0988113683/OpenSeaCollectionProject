//
//  AssetListViewController.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//

import UIKit
import Combine

class AssetListViewController: UIViewController {
    
    // MARK: - Public methods
    var didSelectCell = PassthroughSubject<Asset, Never>()
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(nibCell: ItemCollectionViewCell.self)
            collectionView.register(nibCell: IndicatorCollectionViewCell.self)
        }
    }
    
    private let viewModel = AssetListViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpBindings()
    }
    
    private func setUpBindings() {
        
        func bindViewModelToView() {
            viewModel.$assets
                .sink(receiveValue: { [weak self] _ in
                    guard let strongSelf = self else{ return }
                    strongSelf.collectionView.reloadData()
                })
                .store(in: &cancellable)
            
            viewModel.$etherAccount
                .sink(receiveValue: { [weak self] item in
                    guard let strongSelf = self else{ return }
                    if let item = item {
                        strongSelf.title = "\(item.balance) ETH"
                    }
                })
                .store(in: &cancellable)
            
            let stateValueHandler: (AssetViewModelState) -> Void = { [weak self] state in
                guard let strongSelf = self else{ return }
                switch state {
                case .loading:
                    break
                case .finishedLoading:
                    break
                case .error(let error):
                    switch error {
                    case .fetchError:
                        break
                    case .errorCode(let hTTPCode, let hTTPErrorMessage):
                        strongSelf.showAlert(title: "\(hTTPCode)", message: hTTPErrorMessage)
                    }
                    break
                }
            }
            
            viewModel.$assetState
                .sink(receiveValue: stateValueHandler)
                .store(in: &cancellable)
            
            let etherAccountValueHandler: (AssetViewModelState) -> Void = { [weak self] state in
                switch state {
                case .loading:
                    break
                case .finishedLoading:
                    break
                case .error(_):
                    guard let strongSelf = self else{ return }
                    strongSelf.title = "Error.."
                }
            }
            
            viewModel.$etherAccountState
                .sink(receiveValue: etherAccountValueHandler)
                .store(in: &cancellable)
        }
        
        bindViewModelToView()
    }
    
}

extension AssetListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.isLoadmoreAvailable() ? (viewModel.assets.count + 1) : viewModel.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        func processItemCell() -> UICollectionViewCell {
            guard let cell: ItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemCollectionViewCell.self), for: indexPath) as? ItemCollectionViewCell else {
                return UICollectionViewCell()
            }
            let item = viewModel.assets[indexPath.row]
            cell.setData(item)
            return cell
        }
        
        func processIndicatorCell() -> UICollectionViewCell {
            guard let cell: IndicatorCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: IndicatorCollectionViewCell.self), for: indexPath) as? IndicatorCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.startAnimating()
            return cell
        }
        
        
        if indexPath.row != viewModel.assets.count {
            return processItemCell()
        } else {
            return processIndicatorCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.assets[indexPath.row]
        self.didSelectCell.send(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //load more data
        if viewModel.assets.count > 0 && indexPath.row > viewModel.assets.count - 5 {
            viewModel.loadMoreAssetIfNeeded()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row != viewModel.assets.count {
            return  CGSize(width: 150 , height: 130)
        }else {
            return  CGSize(width: view.frame.width , height: 30)
        }
    }
    
}


extension AssetListViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true)
    }
}
