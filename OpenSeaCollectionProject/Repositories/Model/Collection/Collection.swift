//
//  Collection.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//

import Foundation

// MARK: - Collection
struct Collection: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}
