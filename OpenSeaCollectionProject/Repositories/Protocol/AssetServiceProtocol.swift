//
//  AssetServiceProtocol.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//

import Foundation
import Combine

public typealias ResponseCompletion<Value> = AnyPublisher<Value, Error> where Value: Decodable


// MARK: - Protocol
protocol AssetServiceProtocol {
    func getAssets(with address: String, offset: Int) -> ResponseCompletion<[Asset]>
}
