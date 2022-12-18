//
//  BaseAPIController.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//

import Foundation
import Combine


public class BaseAPIController {
    
    let session: URLSession = URLSession.shared

    internal func call<Value>(endpoint: Endpoint, httpCodes: HTTPCodes = .success) -> ResponseCompletion<Value> {
        do {
            let request = try endpoint.urlRequest()
            return session
                .dataTaskPublisher(for: request)
                .tryMap {
                    assert(!Thread.isMainThread)
                    guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
                        throw APIError.unexpectedResponse
                    }
                    guard HTTPCodes.success.contains(code) else {
                        let message: String = HTTPURLResponse.localizedString(forStatusCode: code)
                        throw APIError.httpCode(code, message)
                    }
                    return $0.0
                }
                .retry(3)
                .decode(type: Value.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch let error {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }
}
