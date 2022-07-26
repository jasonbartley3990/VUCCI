//
//  Post.swift
//  VUCCI
//
//  Created by Jason bartley on 4/25/22.
//

import Foundation

struct Post: Codable {
    let posterId: String
    let postType: String
    let contentId: String
    let contentType: String
    let contentName: String
    let contentCreator: String
    let contentImageUrl: String
    let postedDate: Double
    let postId: String
}
