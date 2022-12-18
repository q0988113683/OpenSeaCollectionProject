//
//  URL.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//

import Foundation

extension URL {
    static var mainURL: URL {
        URL(string: URLConfigurations.main.rawValue)!
    }
    
    static var etherscanURL: URL {
        URL(string: URLConfigurations.etherscan.rawValue)!
    }
    
    static func createURL(withService serviceURL: URL, andPath path: String) -> URL {
        return serviceURL.appendingPathComponent(path)
    }
}

extension URL {
    func appendQueryItem(name: String, value: String?) -> URL {
        guard value != nil else {
            return self
        }
        return appendingQueryItem(name: name, value: value!)
    }
    func appendQueryItem(name: String, value: Int?) -> URL {
        guard value != nil else {
            return self
        }
        return appendingQueryItem(name: name, value: "\(value!)")
    }
    
    private func appendingQueryItem(name: String, value: String) -> URL {
        guard var urlComponents: URLComponents = URLComponents(string: absoluteString) else {
            return self
        }
        var items = urlComponents.queryItems ?? []
        items.append(URLQueryItem(name: name, value: "\(value)"))
        urlComponents.queryItems = items
        return urlComponents.url!
    }
}

extension URL {
    var isSVGPath: Bool {
        return self.lastPathComponent.contains(".svg")
    }
}
