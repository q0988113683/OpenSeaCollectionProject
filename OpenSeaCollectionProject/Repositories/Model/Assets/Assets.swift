//
//  Assets.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//

import Foundation

// MARK: - Assets
struct Assets: Codable {
    let next: String?
    let previous: String?
    let assets: [Asset]
}
