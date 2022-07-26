//
//  Content.swift
//  VUCCI
//
//  Created by Jason bartley on 2/18/22.
//

import Foundation

struct Content: Codable {
    let name: String
    let isArtist: Bool
    let isSong: Bool
    let isAlbum: Bool
    let isPlaylist: Bool
    let imageUrl: String
    let ArtistName: String
    let contentCreator: String
    let orderNumber: Int?
    let isPublic: Bool
    let contentId: String
    var songIds: [String]
    let yearPosted: String
    let albumId: String?
    let duration: Double?
    var playlistSongCount: Int?
    let totalStreams: Int?
}
