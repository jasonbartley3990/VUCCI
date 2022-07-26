//
//  SongGroupViewModel.swift
//  VUCCI
//
//  Created by Jason bartley on 4/11/22.
//

import Foundation

struct LikeCellPostViewModel {
    let posterId: String
    let songImageUrl: String
    let contentName: String
    let contentCreatorName: String
    let contentType: String
    let contentId: String
}

struct NewMusicPostViewModel {
    let contentCreator: String
    let songImageUrl: String
    let contentName: String
    let contentType: String
    let contentId: String
}

struct NewPlaylistPostViewModel {
    let playlistCreator: String
    let playlistName: String
    let playlistImageUrl: String
    let contentId: String
}
