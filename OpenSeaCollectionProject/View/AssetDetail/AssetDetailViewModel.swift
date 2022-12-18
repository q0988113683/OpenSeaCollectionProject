//
//  AssetDetailViewModel.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/15.
//

import Foundation
import Combine

class AssetDetailViewModel: ObservableObject {
    
    @Published private(set) var assets: Asset
    
    init(assets: Asset) {
        self.assets = assets
    }

    deinit{
        print("deinit")
    }
}
