//
//  AssetListViewModel.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//

import Foundation
import Combine

enum AssetListViewModelError: Error, Equatable {
    case fetchError
    case errorCode(HTTPCode, HTTPErrorMessage)
}

enum AssetViewModelState: Equatable {
    case loading
    case finishedLoading
    case error(AssetListViewModelError)
}

class AssetListViewModel: ObservableObject {
    
    let assetRepositories: AssetServiceProtocol
    let etherscanRepositories: EtherscanServiceProtocol
    
   
    
    @Published private(set) var assets: [Asset] = []
    @Published private(set) var assetState: AssetViewModelState = .finishedLoading
    
    @Published private(set) var etherAccount: EtherscanAccount?
    @Published private(set) var etherAccountState: AssetViewModelState = .finishedLoading
    
    private var currentPage = 0
    private var canLoadMorePages = true
    private let maxCount = 20
    private var cancellable = Set<AnyCancellable>()
    
    public init(repositories: AssetServiceProtocol = AssetService(),
         etherscanRepositories: EtherscanServiceProtocol = EtherscanService()) {
        self.assetRepositories = repositories
        self.etherscanRepositories = etherscanRepositories
        self.fetchInitAssetsData()
        self.fetchInitEtherAccountData()
    }
    
    func loadMoreAssetIfNeeded() {
        guard assetState != .loading && canLoadMorePages else {
            return
        }
        
        assetState = .loading
        
        currentPage = currentPage + 1
        
        let assetValueHandler: ([Asset]) -> Void = { [weak self] items in
            guard let strongSelf = self else{ return }
            strongSelf.assets.append(contentsOf: items)
            
            if items.count < strongSelf.maxCount {
                strongSelf.canLoadMorePages = false
            }
        }
        
        assetRepositories
            .getAssets(with: "0x85fD692D2a075908079261F5E351e7fE0267dB02", offset: (currentPage * maxCount) + 1)
            .sink(receiveCompletion: assetCompletionHandler(), receiveValue: assetValueHandler)
            .store(in: &cancellable)
    }
    
    func fetchInitAssetsData() {
        guard assetState != .loading else {
            return
        }
        
        assetState = .loading
        canLoadMorePages = true
        currentPage = 0
        
        let assetValueHandler: ([Asset]) -> Void = { [weak self] items in
            guard let strongSelf = self else{ return }
            strongSelf.assets = items
            strongSelf.assetState = .finishedLoading
        }
        
        assetRepositories
            .getAssets(with: "0x85fD692D2a075908079261F5E351e7fE0267dB02", offset: 0)
            .sink(receiveCompletion: assetCompletionHandler(), receiveValue: assetValueHandler)
            .store(in: &cancellable)
    }
    
    func fetchInitEtherAccountData() {
        guard etherAccountState != .loading else {
            return
        }
        
        etherAccountState = .loading
        
        let etherscanValueHandler: (EtherscanAccount) -> Void = { [weak self] item in
            guard let strongSelf = self else{ return }
            strongSelf.etherAccount = item
        }
        
        let etherscanCompletionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            guard let strongSelf = self else{ return }
            switch completion {
            case .failure(let error):
                if let error = error as? APIError {
                    switch error {
                    case .invalidURL:
                        strongSelf.etherAccountState = .error(.fetchError)
                    case .invalidRequest:
                        strongSelf.etherAccountState = .error(.fetchError)
                    case .httpCode(let hTTPCode, let hTTPErrorMessage):
                        strongSelf.etherAccountState = .error(.errorCode(hTTPCode, hTTPErrorMessage))
                    case .unexpectedResponse:
                        strongSelf.etherAccountState = .error(.fetchError)
                    }
                }
            case .finished:
                strongSelf.etherAccountState = .finishedLoading
            }
        }
        
        etherscanRepositories
            .getBalance(with: "0x45e538f3c138a1580850d7e822b68e995e787033")
//            .getBalance(with: "0x85fD692D2a075908079261F5E351e7fE0267dB02")
            .sink(receiveCompletion: etherscanCompletionHandler, receiveValue: etherscanValueHandler)
            .store(in: &cancellable)
    }
    
    private func assetCompletionHandler() -> (Subscribers.Completion<Error>) -> Void {
        return { [weak self] completion in
            guard let strongSelf = self else{ return }
            switch completion {
            case .failure(let error):
                if let error = error as? APIError {
                    switch error {
                    case .invalidURL:
                        strongSelf.assetState = .error(.fetchError)
                    case .invalidRequest:
                        strongSelf.assetState = .error(.fetchError)
                    case .httpCode(let hTTPCode, let hTTPErrorMessage):
                        strongSelf.assetState = .error(.errorCode(hTTPCode, hTTPErrorMessage))
                    case .unexpectedResponse:
                        strongSelf.assetState = .error(.fetchError)
                    }
                }
            case .finished:
                strongSelf.assetState = .finishedLoading
            }
        }
    }
}


extension AssetListViewModel {
    func isLoadmoreAvailable() -> Bool {
        return canLoadMorePages
    }
}
