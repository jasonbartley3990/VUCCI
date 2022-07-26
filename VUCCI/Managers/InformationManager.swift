//
//  InformationManager.swift
//  VUCCI
//
//  Created by Jason bartley on 5/5/22.
//

import Foundation
import UIKit

final class InformationManager {
    static let shared = InformationManager()
    
    private init() {}
    
    public var allPlaylists: [Content] = []
    
    public var hasPlaylistsBeenFetchedFromDatabase: Bool = false
    
    public var profileImage: UIImage?
    
    //MARK: search history items
    
    public var MainSearchHistory: [Content] = [] {
        didSet {
            while MainSearchHistory.count >= 20 {
                MainSearchHistory.removeFirst()
            }
        }
    }
    
    public var UserSearchHistory: [User] = [] {
        didSet {
            while UserSearchHistory.count >= 20 {
                UserSearchHistory.removeFirst()
            }
        }
    }
    
    public var SongSearchHistory: [Content] = [] {
        didSet {
            while SongSearchHistory.count >= 20 {
                SongSearchHistory.removeFirst()
            }
        }
    }
    
    public var AlbumSearchHistory: [Content] = [] {
        didSet {
            while AlbumSearchHistory.count >= 20 {
                AlbumSearchHistory.removeFirst()
            }
        }
    }
    
    public func addItem(content: Content) {
        if (self.MainSearchHistory.contains { item in
            if item.contentId == content.contentId {
                return true
            } else {
                return false
            }
        }) == false {
            self.MainSearchHistory.append(content)
        }
        
        if content.isSong {
            if (self.SongSearchHistory.contains { item in
                if item.contentId == content.contentId {
                    return true
                } else {
                    return false
                }
            }) == false {
                self.SongSearchHistory.append(content)
            }
        }
        
        if content.isAlbum {
            if (self.AlbumSearchHistory.contains { item in
                if item.contentId == content.contentId {
                    return true
                } else {
                    return false
                }
            }) == false {
                self.AlbumSearchHistory.append(content)
            }
        }
    }
    
    //MARK: user info
    
    public func getUserId() -> String? {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            return nil
        }
        return userId
    }
    
    public func getUsername() -> String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return nil
        }
        return username
    }
    
    public func isAnArtistAccount() -> String? {
        guard let isAnArtist = UserDefaults.standard.string(forKey: "isAnArtist") else {
            return nil
        }
        return isAnArtist
    }
    
    
}
//privacy policy
//https://www.privacypolicies.com/live/bb87099e-22e4-4e64-93d7-6a655a0a0c8b
