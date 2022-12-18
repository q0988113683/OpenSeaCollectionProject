//
//  Endpoint+etherscan.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/17.
//

import Foundation

public enum EtherscanEndpoint {
    case getBalance(String)
}

extension EtherscanEndpoint: Endpoint{
    
    public var url: URL {
        switch self {
        case .getBalance(let address):
            return URL.createURL(withService: .etherscanURL, andPath: "api")
                .appendQueryItem(name: "module", value: "account")
                .appendQueryItem(name: "action", value: "balancemulti")
                .appendQueryItem(name: "address", value: address)
                .appendQueryItem(name: "tag", value: "latest")
                .appendQueryItem(name: "apikey", value: "7JZG3RXKS9QGXX7455Q25SX19BTV71FBUU")
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getBalance:
            return .get
        }
    }
    

    public var header: HeaderType {
        return .standard
    }
}
