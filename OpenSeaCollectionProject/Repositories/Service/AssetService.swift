//
//  AssetService.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//

import Foundation
import Combine




// MARK: - Service
final class AssetService: BaseAPIController, AssetServiceProtocol {
    
    func getAssets(with address: String, offset: Int) -> ResponseCompletion<[Asset]> {
        let call: AnyPublisher<Assets, Error> = call(endpoint: AssetEndpoint.getAssets(address, offset))
        return call
            .tryMap { response -> [Asset] in
                return response.assets
            }
            .eraseToAnyPublisher()
    }
}
