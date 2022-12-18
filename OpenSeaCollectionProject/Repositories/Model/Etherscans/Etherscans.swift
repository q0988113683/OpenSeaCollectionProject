//
//  Etherscans.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/17.
//

import Foundation

// MARK: - Etherscans
struct Etherscans: Codable {
    let result: [EtherscanAccount]

    enum CodingKeys: String, CodingKey {
        case result
    }
}


