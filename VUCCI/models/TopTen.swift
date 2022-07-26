//
//  TopTen.swift
//  VUCCI
//
//  Created by Jason bartley on 5/5/22.
//

import Foundation

struct TopTen: Codable {
    let rank: Int
    let contentId: String
    let name: String
    let artist: String
    let imageUrl: String
}

struct TopFive: Codable {
    let rank: Int
    let contentId: String
    let name: String
    let artist: String
    let imageUrl: String
}
