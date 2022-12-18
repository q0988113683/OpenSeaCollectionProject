//
//  EtherscanService.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/17.
//

import Foundation
import Combine

// MARK: - Service
final class EtherscanService: BaseAPIController, EtherscanServiceProtocol {
    
    func getBalance(with address: String) -> ResponseCompletion<EtherscanAccount> {
        let call: AnyPublisher<Etherscans, Error> = call(endpoint: EtherscanEndpoint.getBalance(address))
        return call
            .tryMap { response -> EtherscanAccount in
                if let item = response.result.first  {
                    return item
                }
                throw APIError.unexpectedResponse
            }
            .eraseToAnyPublisher()
    }
}
