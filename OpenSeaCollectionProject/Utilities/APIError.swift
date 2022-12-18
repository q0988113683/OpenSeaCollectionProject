//
//  APIError.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//
import Foundation

public typealias HTTPCode = Int
public typealias HTTPErrorMessage = String
public typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    public static let success = 200 ..< 300
}

public enum APIError: Swift.Error {
    case invalidURL
    case invalidRequest
    case httpCode(HTTPCode, HTTPErrorMessage)
    case unexpectedResponse
}
