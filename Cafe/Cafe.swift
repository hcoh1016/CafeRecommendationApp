//
//  Cafe.swift
//  Cafe
//
//  Created by Mac on 2026/06/12.
//

import Foundation

struct Cafe: Codable {
    let name: String
    let region: String
    let address: String
    let description: String
    let latitude: Double
    let longitude: Double
    let imageName: String
    let keywords: [String]
}
