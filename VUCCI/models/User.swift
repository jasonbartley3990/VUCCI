//
//  User.swift
//  VUCCI
//
//  Created by Jason bartley on 4/21/22.
//

import Foundation

struct User: Codable {
    let isAnArtistAccount: Bool
    let email: String
    let username: String
    let firstName: String
    let lastName: String
    let artistName: String?
    let dateJoined: Double
    let userId: String
    let profileUrl: String?
}
