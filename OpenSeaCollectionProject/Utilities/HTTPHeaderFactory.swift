//
//  HTTPHeaderFactory.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/14.
//

import Foundation

struct HTTPHeaderFactory {
    public static func createHeader() -> [String: String] {
        return ["Content-Type": "application/json"]
    }
}
