//
//  Endpoint.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//

import Foundation


public typealias Parameter = Data

public enum HTTPMethod: String {
    case get = "GET"
}

public enum HeaderType{
    case standard
}

extension HeaderType {
    func createHeader() -> [String: String] {
        switch self {
        case .standard:
            return HTTPHeaderFactory.createHeader()
        }
    }
}

public protocol Endpoint {
    var url: URL { get }
    var method: HTTPMethod { get }
    var header: HeaderType { get }
}

extension Endpoint {
    func urlRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = HTTPHeaderFactory.createHeader()
        return request
    }
}
