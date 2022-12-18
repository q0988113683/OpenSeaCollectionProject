//
//  Endpoint+Assets.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//

import Foundation

public enum AssetEndpoint {
    case getAssets(String, Int)
}

extension AssetEndpoint: Endpoint{
    
    public var url: URL {
        switch self {
        case .getAssets(let address, let offset):
            return URL.createURL(withService: .mainURL, andPath: "assets")
                .appendQueryItem(name: "owner", value: address)
                .appendQueryItem(name: "offset", value: offset)
                .appendQueryItem(name: "limit", value: 20)
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getAssets:
            return .get
        }
    }
    

    public var header: HeaderType {
        return .standard
    }
}
