//
//  EtherscanServiceProtocol.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/17.
//

import Foundation

// MARK: - Protocol
protocol EtherscanServiceProtocol {
    func getBalance(with address: String) -> ResponseCompletion<EtherscanAccount>
}
