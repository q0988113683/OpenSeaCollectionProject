//
//  Asset.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//

import Foundation

// MARK: - Asset
struct Asset: Codable {
    let id: Int
    let imageURL: String?
    let name, assetDescription: String
    let permalink: String
    let collection: Collection

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case name
        case assetDescription = "description"
        case permalink, collection
    }
}



