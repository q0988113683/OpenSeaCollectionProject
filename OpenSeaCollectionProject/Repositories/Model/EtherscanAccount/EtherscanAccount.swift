//
//  EtherscanAccount.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/17.
//

import Foundation


// MARK: - Etherscans
struct EtherscanAccount: Codable {
    let account: String
    let balance: String

    enum CodingKeys: String, CodingKey {
        case account
        case balance
    }
}
