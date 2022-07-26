//
//  DatabaseManager.swift
//  VUCCI
//
//  Created by Jason bartley on 4/30/22.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {}
    
    let database = Firestore.firestore()
    
    public var isPaginating = false
    
    
    //MARK: create a user
    
    public func createUser(newuser: User, completion: @escaping (Bool) -> Void) {
        
        let batch = database.batch()
        
        guard let userData = newuser.asDictionary() else {
            completion(false)
            return
        }
        let userReference = database.document("users/\(newuser.userId)")
        batch.setData(userData, forDocument: userReference)
        
        
        guard let firstTopTen = TopTen(rank: 1, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let firstTopTenRef = database.collection("users").document(newuser.userId).collection("topTen").document("first")
        batch.setData(firstTopTen, forDocument: firstTopTenRef)
        
        
        guard let secondTopTen = TopTen(rank: 2, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let secondTopTenRef = database.collection("users").document(newuser.userId).collection("topTen").document("second")
        batch.setData(secondTopTen, forDocument: secondTopTenRef)
        
        
        guard let thirdTopTen = TopTen(rank: 3, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let thirdTopTenRef = database.collection("users").document(newuser.userId).collection("topTen").document("third")
        batch.setData(thirdTopTen, forDocument: thirdTopTenRef)
        
        
        guard let fourthTopTen = TopTen(rank: 4, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let fourthTopTenRef = database.collection("users").document(newuser.userId).collection("topTen").document("fourth")
        batch.setData(fourthTopTen, forDocument: fourthTopTenRef)
        
        
        guard let fifthTopTen = TopTen(rank: 5, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let fifthTopTenRef = database.collection("users").document(newuser.userId).collection("topTen").document("fifth")
        batch.setData(fifthTopTen, forDocument: fifthTopTenRef)
        
        
        guard let sixthTopTen = TopTen(rank: 6, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let sixthTopTenRef = database.collection("users").document(newuser.userId).collection("topTen").document("sixth")
        batch.setData(sixthTopTen, forDocument: sixthTopTenRef)
        
        
        guard let seventhTopTen = TopTen(rank: 7, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let seventhTopTenRef = database.collection("users").document(newuser.userId).collection("topTen").document("seventh")
        batch.setData(seventhTopTen, forDocument: seventhTopTenRef)
        
        
        guard let eighthTopTen = TopTen(rank: 8, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let eighthTopTenRef = database.collection("users").document(newuser.userId).collection("topTen").document("eighth")
        batch.setData(eighthTopTen, forDocument: eighthTopTenRef)
        
        
        guard let ninthTopTen = TopTen(rank: 9, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let ninthTopTenRef = database.collection("users").document(newuser.userId).collection("topTen").document("ninth")
        batch.setData(ninthTopTen, forDocument: ninthTopTenRef)
        
        
        guard let tenthTopTen = TopTen(rank: 10, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let tenthTopTenRef = database.collection("users").document(newuser.userId).collection("topTen").document("tenth")
        batch.setData(tenthTopTen, forDocument: tenthTopTenRef)
        
        
        guard let firstTopFive = TopFive(rank: 1, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let firstTopFiveRef = database.collection("users").document(newuser.userId).collection("topFive").document("first")
        batch.setData(firstTopFive, forDocument: firstTopFiveRef)
        
        
        guard let secondTopFive = TopFive(rank: 2, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let secondTopFiveRef = database.collection("users").document(newuser.userId).collection("topFive").document("second")
        batch.setData(secondTopFive, forDocument: secondTopFiveRef)
        
        
        guard let thirdTopFive = TopFive(rank: 3, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let thirdTopFiveRef = database.collection("users").document(newuser.userId).collection("topFive").document("third")
        batch.setData(thirdTopFive, forDocument: thirdTopFiveRef)
        
        
        guard let fourthTopFive = TopFive(rank: 4, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let fourthTopFiveRef = database.collection("users").document(newuser.userId).collection("topFive").document("fourth")
        batch.setData(fourthTopFive, forDocument: fourthTopFiveRef)
        
        
        guard let fifthTopFive = TopFive(rank: 5, contentId: "", name: "---", artist: "---", imageUrl: "").asDictionary() else {
            completion(false)
            return
        }
        let fifthTopFiveRef = database.collection("users").document(newuser.userId).collection("topFive").document("fifth")
        batch.setData(fifthTopFive, forDocument: fifthTopFiveRef)
        
        batch.commit(completion: {
            error in
            completion(error == nil)
        })
        
    }
    
    //MARK: change username
    
    public func changeUsername(newUsername: String, userId: String, completion: @escaping (Bool) -> Void) {
        let ref = database.collection("users").document(userId)
        ref.updateData(["username": newUsername]) {
            error in
            completion(error == nil)
        }
    }
    
    //MARK: change account type
    
    public func changeAccountToAnArtistAccount(userId: String, artistName: String, artistContent: Content?, wasPreviouslyAnArtist: Bool, completion: @escaping (Bool) -> Void) {
        
        let batch = database.batch()
        
        let userRef = database.collection("users").document(userId)
        
        if wasPreviouslyAnArtist == false {
            batch.updateData(["isAnArtistAccount": true, "artistName": artistName], forDocument: userRef)
        } else {
            batch.updateData(["isAnArtistAccount": true], forDocument: userRef)
        }
        
        
        let contentRef = database.collection("content").document(userId)
        
        if wasPreviouslyAnArtist  == false {
            guard let artistData = artistContent?.asDictionary() else {
                completion(false)
                return
            }
            batch.setData(artistData, forDocument: contentRef)
        } else {
            batch.updateData(["isPublic": true], forDocument: contentRef)
        }
        
        batch.commit(completion: {
            error in
            completion(error == nil)
        })
    }
    
    //MARK: change account to a listener
    
    public func changeAccountToAListener(userId: String, completion: @escaping(Bool) -> Void) {
        let batch = database.batch()
        
        let userRef = database.collection("users").document(userId)
        batch.updateData(["isAnArtistAccount": false], forDocument: userRef)
        
        let contentRef = database.collection("content").document(userId)
        batch.updateData(["isPublic": false], forDocument: contentRef)
        
        batch.commit()
    }
    
    
    //MARK: find users
    
    public func findAUserWithId(userId: String, completion: @escaping (User?) -> Void) {
        let ref = database.collection("users").document(userId)
        ref.getDocument { snapshot, error in
            guard error == nil else {
                completion(nil)
                return
            }
            guard let data = snapshot?.data(), let userInfo = User(with: data) else {
                completion(nil)
                return
            }
            completion(userInfo)
        }
        
        
    }
    
    
    public func findUserWithEmail(with email: String, completion: @escaping (User?) -> Void) {
        let ref = database.collection("users")
        ref.whereField("email", isEqualTo: email).getDocuments(completion: { snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }), error == nil else {
                completion(nil)
                return
            }
            let user = users.first(where: { $0.email == email })
            completion(user)
        })
    }
    
    public func findUserWithUsername(with username: String, completion: @escaping (User?) -> Void) {
        let ref = database.collection("users")
        ref.whereField("username", isEqualTo: username).getDocuments(completion: {
            snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data() )}), error == nil else {
                completion(nil)
                return
            }
            let user = users.first(where: { $0.username == username})
            completion(user)
        })
    }
    
    public func findUsers(with usernamePrefix: String, completion: @escaping ([User]) -> Void) {
        let ref = database.collection("users")
        ref.whereField("username", isGreaterThanOrEqualTo: usernamePrefix).limit(to: 10).getDocuments(completion: {
            snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }), error == nil else {
                completion([])
                return
            }
            let subset = users.filter({ $0.username.lowercased().hasPrefix(usernamePrefix.lowercased())})
            completion(subset)
        })
    }
    
    //MARK: grab a users song collections and playlist
    
    public func grabUsersPlaylists(userId: String, completion: @escaping ([Content]) -> Void) {
        let ref = database.collection("users").document(userId).collection("songGroups")
        ref.getDocuments(completion: {
            snapshot, error in
            guard let songGroups = snapshot?.documents.compactMap({ Content(with: $0.data() )}), error == nil else {
                completion([])
                return
            }
            completion(songGroups)
        })
    }
    
    //MARK: grab a users playlist that he has created
    
    public func grabFiveUserPlaylistThatCreated(userId: String, completion: @escaping ([Content]?) -> Void) {
        let ref = database.collection("content").whereField("isPlaylist", isEqualTo: true).whereField("contentCreator", isEqualTo: userId).whereField("isPublic", isEqualTo: true).limit(to: 5)
        ref.getDocuments(completion: {
            snapshot, error in
            guard let songGroups = snapshot?.documents.compactMap({ Content(with: $0.data() )}), error == nil else {
                completion(nil)
                return
            }
            completion(songGroups)
        })
    }
    
    public func grabAllUserPlaylistThatCreated(userId: String, completion: @escaping ([Content]) -> Void) {
        let ref = database.collection("content").whereField("isPlaylist", isEqualTo: true).whereField("contentCreator", isEqualTo: userId).whereField("isPublic", isEqualTo: true)
        ref.getDocuments(completion: {
            snapshot, error in
            guard let songGroups = snapshot?.documents.compactMap({ Content(with: $0.data() )}), error == nil else {
                completion([])
                return
            }
            completion(songGroups)
        })
    }
    
    //MARK: upload content
    
    public func uploadASong(content: Content, completion: @escaping(Bool) -> Void) {
        let batch = database.batch()
        
        let songRef = database.collection("content").document(content.contentId)
        guard let songData = content.asDictionary() else {
            completion(false)
            return
        }
        
        batch.setData(songData, forDocument: songRef)
        
        let uniquePostId = UUID().uuidString
        let postedDate = NSDate().timeIntervalSince1970
        let newPost = Post(posterId: content.contentCreator, postType: "newMusic", contentId: content.contentId, contentType: "song", contentName: content.name, contentCreator: content.contentCreator, contentImageUrl: content.imageUrl, postedDate: postedDate, postId: uniquePostId)
        guard let postData = newPost.asDictionary() else{
            completion(false)
            return
            
        }
        let postReference = database.collection("posts").document(uniquePostId)
        
        batch.setData(postData, forDocument: postReference)
        
        batch.commit(completion: {
            error in
            completion(error == nil)
        })
    }
    
    //MARK: upload an album
    
    public func uploadAnAlbum(songs: [Content], albumId: String, albumContent: Content, completion: @escaping (Bool) -> Void) {
        let batch = database.batch()
        
        let songCount = songs.count
        
        if songCount >= 1 {
            let song = songs[0]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let firstSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: firstSongReference)
        }
        
        if songCount >= 2 {
            let song = songs[1]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let secondSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: secondSongReference)
        }
        
        if songCount >= 3 {
            let song = songs[2]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let thirdSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: thirdSongReference)
        }
        
        if songCount >= 4 {
            let song = songs[3]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let fourthSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: fourthSongReference)
        }
        
        if songCount >= 5 {
            let song = songs[4]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let fifthSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: fifthSongReference)
        }
        
        if songCount >= 6 {
            let song = songs[5]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let sixthSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: sixthSongReference)
        }
        
        if songCount >= 7 {
            let song = songs[6]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let seventhSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: seventhSongReference)
        }
        
        if songCount >= 8 {
            let song = songs[7]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let eigthSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: eigthSongReference)
            
        }
        
        if songCount >= 9 {
            let song = songs[8]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let ninthSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: ninthSongReference)
            
        }
        
        if songCount >= 10 {
            let song = songs[9]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let tenthSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: tenthSongReference)
            
        }
        
        if songCount >= 11 {
            let song = songs[10]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let eleventhSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: eleventhSongReference)
        }
        
        if songCount >= 12 {
            let song = songs[11]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let twelthSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: twelthSongReference)
        }
        
        if songCount >= 13 {
            let song = songs[12]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let thirtenthSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: thirtenthSongReference)
        }
        
        if songCount >= 14 {
            let song = songs[13]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let fourtenthSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: fourtenthSongReference)
        }
        
        if songCount >= 15 {
            let song = songs[14]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let fiftenthSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: fiftenthSongReference)
        }
        
        if songCount >= 16 {
            let song = songs[15]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let sixtenthSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: sixtenthSongReference)
        }
        
        if songCount >= 17 {
            let song = songs[16]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let sevententhSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: sevententhSongReference)
        }
        
        if songCount >= 18 {
            let song = songs[17]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let eigtenthSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: eigtenthSongReference)
        }
        
        if songCount >= 19 {
            let song = songs[18]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let ninetenthSongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: ninetenthSongReference)
        }
        
        if songCount >= 20 {
            let song = songs[19]
            guard let songData = song.asDictionary() else {
                completion(false)
                return
            }
            let twentySongReference = database.collection("content").document(song.contentId)
            batch.setData(songData, forDocument: twentySongReference)
        }
        
        guard let newAlbum = albumContent.asDictionary() else {
            completion(false)
            return
        }
        let albumReference = database.collection("content").document(albumId)
        batch.setData(newAlbum, forDocument: albumReference)
        
        let uniquePostId = UUID().uuidString
        let postedDate = NSDate().timeIntervalSince1970
        let newPost = Post(posterId: albumContent.contentCreator, postType: "newMusic", contentId: albumContent.contentId, contentType: "album", contentName: albumContent.name, contentCreator: albumContent.contentCreator, contentImageUrl: albumContent.imageUrl, postedDate: postedDate, postId: uniquePostId)
        guard let postData = newPost.asDictionary() else {
            completion(false)
            return
        }
        
        let newPostRef = database.collection("posts").document(uniquePostId)
        batch.setData(postData, forDocument: newPostRef)
        
        batch.commit(completion: {
            error in
            completion(error == nil)
        })
        
    }
    
    //MARK: create the initial liked playlist
    
    public func createLikedPlaylistForUser(userId: String, email: String, completion: @escaping (Bool) -> Void) {
        let ref = database.collection("users").document(userId).collection("songGroups").document("liked")
        let likedContent = Content(name: "Liked Songs", isArtist: false, isSong: false, isAlbum: false, isPlaylist: true, imageUrl: "", ArtistName: "", contentCreator: userId, orderNumber: nil, isPublic: false, contentId: "", songIds: [], yearPosted: "", albumId: nil, duration: nil, playlistSongCount: 0, totalStreams: nil)
        guard let data = likedContent.asDictionary() else {
            completion(false)
            return
        }
        ref.setData(data) {
            error in
            completion(error == nil)
        }
    }
    
    //MARK: create a new playlist
    
    public func createPlaylist(userId: String, playlistId: String, content: Content, completion: @escaping (Bool) -> Void) {
        
        let batch = database.batch()
        
        guard let data = content.asDictionary() else {
            completion(false)
            return
        }
        
        let userRef = database.collection("users").document(userId).collection("songGroups").document(playlistId)
        batch.setData(data, forDocument: userRef)
        
        
        let contentCollectionRef = database.collection("content").document(content.contentId)
        batch.setData(data, forDocument: contentCollectionRef)
        
        let uniquePostId = UUID().uuidString
        let postedDate = NSDate().timeIntervalSince1970
        
        let newPost = Post(posterId: userId, postType: "newPlaylist", contentId: playlistId, contentType: "playlist", contentName: content.name, contentCreator: content.contentCreator, contentImageUrl: content.imageUrl, postedDate: postedDate, postId: uniquePostId)
        guard let postData = newPost.asDictionary() else {
            completion(false)
            return
        }
        
        let postCollectionRef =  database.collection("posts").document(uniquePostId)
        batch.setData(postData, forDocument: postCollectionRef)
        
        batch.commit(completion: {
            error in
            completion(error == nil)
        })
        
    }
    
    //MARK: delete a playlist
    
    public func deleteAPlaylist(playlistId: String, poster: String, post: String, completion: @escaping (Bool) -> Void) {
        let batch = database.batch()
        
        let userPlaylistReference = database.collection("users").document(poster).collection("songGroups").document(playlistId)
        batch.deleteDocument(userPlaylistReference)
        
        let contentPlaylistReference = database.collection("content").document(playlistId)
        batch.deleteDocument(contentPlaylistReference)
        
        let postReference = database.collection("posts").document(post)
        batch.deleteDocument(postReference)
        
        batch.commit(completion: {
            error in
            completion(error == nil)
        })
    }
    
    //MARK: delete a song from a playlist
    
    public func deleteASongFromPlaylist(playlist: Content, songToRemoveId: String, userId: String, completion: @escaping (Bool) -> Void) {
        let batch = database.batch()
        
        var newPlaylist: Content = playlist
        
        for (index, song) in playlist.songIds.enumerated() {
            if song == songToRemoveId {
                newPlaylist.songIds.remove(at: index)
            }
        }
        
        guard let playlistSongCount = newPlaylist.playlistSongCount else {
            completion(false)
            return
        }
        
        newPlaylist.playlistSongCount = (playlistSongCount - 1)
        
        guard let newPlaylistData = newPlaylist.asDictionary() else {
            completion(false)
            return
        }
        
        let userContentRef = database.collection("users").document(userId).collection("songGroups").document(playlist.contentId)
        batch.setData(newPlaylistData, forDocument: userContentRef)
        
        
        let contentRef = database.collection("content").document(playlist.contentId).collection("songs").document(songToRemoveId)
        batch.deleteDocument(contentRef)
        
        batch.commit(completion: {
            error in
            completion(error == nil)
        })
        
    }
    
    
    //MARK: add song to a playlist
    
    public func addSongToPlaylist(songToAdd: Content, orderNum: Int, playlist: Content, completion: @escaping(Bool) -> Void) {
        
        let batch = database.batch()
        
        let songForPlaylistRef = database.collection("content").document(playlist.contentId).collection("songs").document(songToAdd.contentId)
        
        let songForPlaylist = Content(name: songToAdd.name, isArtist: songToAdd.isArtist, isSong: songToAdd.isSong, isAlbum: songToAdd.isAlbum, isPlaylist: songToAdd.isPlaylist, imageUrl: songToAdd.imageUrl, ArtistName: songToAdd.ArtistName, contentCreator: songToAdd.contentCreator, orderNumber: orderNum, isPublic: songToAdd.isPublic, contentId: songToAdd.contentId, songIds: songToAdd.songIds, yearPosted: songToAdd.yearPosted, albumId: songToAdd.albumId, duration: songToAdd.duration, playlistSongCount: nil, totalStreams: nil)
        
        guard let song = songForPlaylist.asDictionary() else {
            return
        }
        batch.setData(song, forDocument: songForPlaylistRef)
        
        
        let playlistRef = database.collection("content").document(playlist.contentId)
        guard let playlistSongCount = playlist.playlistSongCount else {
            return
        }
        let newPlaylistCount = playlistSongCount + 1
        batch.updateData(["playlistSongCount": orderNum], forDocument: playlistRef)
        
        guard let user = UserDefaults.standard.string(forKey: "userId") else {return}
        let userSidePlaylistRef = database.collection("users").document(user).collection("songGroups").document(playlist.contentId)
        batch.updateData(["playlistSongCount": orderNum], forDocument: userSidePlaylistRef)
        
        
        batch.commit(completion: {
            error in
            completion(error == nil)
        })
    }
    
    
    //MARK: like a song / unlike a song
    
    public func addToLikedSongs(user: String, song: Content, completion: @escaping(Bool) -> Void) {
        
        let batch = database.batch()
        
        let userRef = database.collection("users").document(user).collection("songGroups").document("liked").collection("songs").document(song.contentId)
        guard let songData = song.asDictionary() else {
            completion(false)
            return
        }
        batch.setData(songData, forDocument: userRef)
        
        batch.commit(completion: {
            error in
            completion(error == nil)
        })
        
    }
    
    public func removeFromLikedSongs(user: String, song: Content, completion: @escaping(Bool) -> Void) {
        let ref = database.collection("users").document(user).collection("songGroups").document("liked").collection("songs").document(song.contentId)
        ref.delete(completion: {
            error in
            completion(error == nil)
        })
    }
    
    //MARK: check if it was liked
    
    public func isALikedSong(user: String, songId: String, completion: @escaping(Bool) -> Void) {
        let ref = database.collection("users").document(user).collection("songGroups").document("liked").collection("songs").document(songId)
        ref.getDocument { snapshot, error in
            guard error == nil else {
                completion(false)
                return
            }
            guard let data = snapshot?.data() else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    //MARK: grab liked songs
    
    public func grabUsersLikedSongs(userId: String, completion: @escaping([Content]?) -> Void) {
        let ref = database.collection("users").document(userId).collection("songGroups").document("liked").collection("songs")
        ref.getDocuments(completion: {
            snapshot, error in
            guard let songs = snapshot?.documents.compactMap({ Content(with:  $0.data()) }), error == nil else {
                completion(nil)
                return
            }
            completion(songs)
        })
        
    }
    
   //MARK: grab songs from a playlist
    
    public func grabSongsFromPlaylist(playlist: String, completion: @escaping([Content]) -> Void) {
        let ref = database.collection("content").document(playlist).collection("songs")
        ref.getDocuments(completion: {
            snapshot, error in
            guard let songs = snapshot?.documents.compactMap({ Content(with: $0.data() )}), error == nil else {
                completion([])
                return
            }
            completion(songs)
        })
        
    }
    
    //MARK: add a Song Group to collection
    
    public func addSongGroupToCollection(user: String, content: Content, completion: @escaping(Bool) -> Void) {
        let batch = database.batch()
        
        
        let userSongGroupRef = database.collection("users").document(user).collection("songGroups").document(content.contentId)
        guard let groupData = content.asDictionary() else {
            completion(false)
            return
        }
        
        batch.setData(groupData, forDocument: userSongGroupRef)
        
        let songGroupContentRef = database.collection("content").document(content.contentId).collection("likers").document(user)
        batch.setData(["user": user], forDocument: songGroupContentRef)
        
        batch.commit(completion: {
            error in
            completion(error == nil)
        })
        
    }
    
    //MARK: remove song group from collection
    
    public func removeSongGroupFromCollection(user: String, content: Content, completion: @escaping(Bool) -> Void) {
        let batch = database.batch()
        
        let userSongGroupRef = database.collection("users").document(user).collection("songGroups").document(content.contentId)
        batch.deleteDocument(userSongGroupRef)
        
        let songGroupContentRef = database.collection("content").document(content.contentId).collection("likers").document(user)
        batch.deleteDocument(songGroupContentRef)
        
        batch.commit(completion: {
            error in
            completion(error == nil)
        })
        
    }
    
    
    
    
    //MARK: grab an artist top 5 songs (that they posted)
    
    public func grabAnArtistTopFiveSongs(userId: String, completion: @escaping([Content]?) -> Void) {
        let ref = database.collection("content")
        ref.whereField("contentCreator", isEqualTo: userId).whereField("isSong", isEqualTo: true).order(by: "totalStreams", descending: true).limit(to: 5).getDocuments(completion: {
            snapshot, error in
            guard let songs = snapshot?.documents.compactMap({ Content(with:  $0.data()) }), error == nil else {
                completion(nil)
                return
            }
            completion(songs)
        })
    }
    
    //MARK: grab 5 artists albums
    
    public func grabAnArtistsFiveAlbums(userId: String, completion: @escaping([Content]?) -> Void) {
        let ref = database.collection("content")
        ref.whereField("contentCreator", isEqualTo: userId).whereField("isAlbum", isEqualTo: true).limit(to: 5).getDocuments(completion: {
            snapshot, error in
            guard let albums = snapshot?.documents.compactMap({ Content(with:  $0.data()) }), error == nil else {
                completion(nil)
                return
            }
            completion(albums)
        })
        
    }
    
    //MARK: grab all of an artist songs
    
    public func grabAllOfAnArtistSongs(userId: String, completion: @escaping([Content]?) -> Void) {
        let ref = database.collection("content")
        ref.whereField("contentCreator", isEqualTo: userId).whereField("isSong", isEqualTo: true).order(by: "totalStreams", descending: true).getDocuments(completion: {
            snapshot, error in
            guard let songs = snapshot?.documents.compactMap({ Content(with:  $0.data()) }), error == nil else {
                completion(nil)
                return
            }
            completion(songs)
        })
    }
    
    
    //MARK: grab all of an artists albums
    
    public func grabAllOfAnArtistAlbums(userId: String, completion: @escaping([Content]?) -> Void) {
        let ref = database.collection("content")
        ref.whereField("contentCreator", isEqualTo: userId).whereField("isAlbum", isEqualTo: true).getDocuments(completion: {
            snapshot, error in
            guard let albums = snapshot?.documents.compactMap({ Content(with:  $0.data()) }), error == nil else {
                completion(nil)
                return
            }
            completion(albums)
        })
        
    }
    
    
    //MARK: grab top 10 songs
    
    public func grabTopTen(user: String, completion: @escaping([TopTen]) -> Void) {
        let ref = database.collection("users").document(user).collection("topTen")
        ref.getDocuments(completion: {
            snapshot, error in
            guard let songs = snapshot?.documents.compactMap({ TopTen(with: $0.data() )}), error == nil else {
                completion([])
                return
            }
            guard songs.count == 10 else {
                completion([])
                return
            }
            completion(songs)
        })
    }
    
    //MARK: grab top 5 albums
    
    public func grabTopFive(user: String, completion: @escaping([TopFive]) -> Void) {
        let ref = database.collection("users").document(user).collection("topFive")
        ref.getDocuments(completion: {
            snapshot, error in
            guard let songs = snapshot?.documents.compactMap({ TopFive(with: $0.data() )}), error == nil else {
                completion([])
                return
            }
            guard songs.count == 5 else {
                completion([])
                return
            }
            completion(songs)
        })
        
    }
    
    
    
    //MARK: checked if content was liked
    
    public func isContentLiked(userId: String, contentId: String, completion: @escaping (Bool) -> Void) {
        let ref = database.collection("content").document(contentId).collection("likers").document(userId)
        ref.getDocument { snapshot, error in
            guard error == nil else {
                completion(false)
                return
            }
            guard let data = snapshot?.data() else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    //MARK: share a post
    
    public func shareAPost(post: Post, postId: String, completion: @escaping (Bool) -> Void) {
        let ref = database.collection("posts").document(postId)
        guard let data = post.asDictionary() else {
            completion(false)
            return
        }
        ref.setData(data, completion: {
            error in
            completion(error == nil)
        })
    }
    
    //MARK: find a post
    
    public func findAPost(contentId: String, completion: @escaping (Post?) -> Void) {
        let ref = database.collection("posts").whereField("contentId", isEqualTo: contentId)
        ref.getDocuments(completion: {
            snapshot, error in
            guard let posts = snapshot?.documents.compactMap({ Post(with: $0.data() )}), error == nil else {
                completion(nil)
                return
            }
            if posts.count != 0 {
                let post = posts[0]
                completion(post)
            } else {
                completion(nil)
            }
        })
    }
    
    
    
    //MARK: find content
    
    public func findContent(with contentPrefix: String, completion: @escaping ([Content]) -> Void) {
        let ref = database.collection("content")
        ref.whereField("name", isGreaterThanOrEqualTo: contentPrefix).limit(to: 10).getDocuments(completion: {
            snapshot, error in
            guard let contents = snapshot?.documents.compactMap({ Content(with: $0.data()) }), error == nil else {
                completion([])
                return
            }
            let subset = contents.filter({ $0.name.lowercased().hasPrefix(contentPrefix.lowercased())})
            completion(subset)
        })
    }
    
    public func findSong(with contentPrefix: String, completion: @escaping ([Content]) -> Void) {
        let ref = database.collection("content")
        ref.whereField("isSong", isEqualTo: true).whereField("name", isGreaterThanOrEqualTo: contentPrefix).limit(to: 10).getDocuments(completion: {
            snapshot, error in
            guard let contents = snapshot?.documents.compactMap({ Content(with: $0.data()) }), error == nil else {
                completion([])
                return
            }
            let subset = contents.filter({ $0.name.lowercased().hasPrefix(contentPrefix.lowercased())})
            completion(subset)
            
        })
    }
    
    public func findSong(withId contentId: String, completion: @escaping(Content?) -> Void) {
        let ref = database.collection("content").document(contentId)
        ref.getDocument(completion: {
            snapshot, error in
            guard let data = snapshot?.data(), let song = Content(with: data) else {
                completion(nil)
                return
            }
            completion(song)
        })
        
    }
    
    public func findAlbum(withId albumId: String, completion: @escaping(Content?) -> Void) {
        let ref = database.collection("content").document(albumId)
        ref.getDocument(completion: {
            snapshot, error in
            guard let data = snapshot?.data(), let album = Content(with: data) else {
                completion(nil)
                return
            }
            completion(album)
        })
    }
    
    
    public func findAlbum(with contentPrefix: String, completion: @escaping ([Content]) -> Void) {
        let ref = database.collection("content")
        ref.whereField("isAlbum", isEqualTo: true).whereField("name", isGreaterThanOrEqualTo: contentPrefix).limit(to: 10).getDocuments(completion: {
            snapshot, error in
            guard let contents = snapshot?.documents.compactMap({ Content(with: $0.data()) }), error == nil else {
                completion([])
                return
            }
            let subset = contents.filter({ $0.name.lowercased().hasPrefix(contentPrefix.lowercased())})
            completion(subset)
            
        })
    }
    
    //MARK: find a playlist
    
    public func findPlaylist(with contentPrefix: String, completion: @escaping ([Content]) -> Void) {
        let ref = database.collection("content")
        ref.whereField("isPlaylist", isEqualTo: true).whereField("name", isGreaterThanOrEqualTo: contentPrefix).limit(to: 20).getDocuments(completion: {
            snapshot, error in
            guard let contents = snapshot?.documents.compactMap({ Content(with: $0.data()) }), error == nil else {
                completion([])
                return
            }
            let subset = contents.filter({ $0.name.lowercased().hasPrefix(contentPrefix.lowercased())})
            completion(subset)
            
        })
    }
    
    //MARK: find a users playlist
    
    public func findAUsersPlaylist(with contentPrefix: String, user: String, completion: @escaping([Content]) -> Void) {
        let ref = database.collection("content")
        ref.whereField("isPlaylist", isEqualTo: true).whereField("contentCreator", isEqualTo: user).whereField("name", isGreaterThanOrEqualTo: contentPrefix).limit(to: 20).getDocuments(completion: {
            snapshot, error in
            guard let contents = snapshot?.documents.compactMap({ Content(with: $0.data() )}), error == nil else {
                completion([])
                return
            }
            let subset = contents.filter({ $0.name.lowercased().hasPrefix(contentPrefix.lowercased())})
            completion(subset)
            
        })
    }
    
    
    //MARK: follow a user
    
    func didFollow(currentUser: String, targetUser:String, completion: @escaping(Bool) -> Void) {
        let batch = database.batch()
        
        let currentUserReference = database.collection("users").document(currentUser).collection("following").document(targetUser)
        let targetUserReference = database.collection("users").document(targetUser).collection("followers").document(currentUser)
        
        batch.setData(["user": targetUser], forDocument: currentUserReference)
        batch.setData(["user": currentUser], forDocument: targetUserReference)
        
        batch.commit(completion: {
            error in
            completion(error == nil)
        })
        
    }
    
    //MARK: unfollow a user
    
    func didUnfollow(currentUser: String, targetUser: String, completion: @escaping(Bool) -> Void) {
        let batch = database.batch()
        
        let currentUserReference = database.collection("users").document(currentUser).collection("following").document(targetUser)
        let targetUserReference = database.collection("users").document(targetUser).collection("followers").document(currentUser)
        
        batch.deleteDocument(currentUserReference)
        batch.deleteDocument(targetUserReference)
        
        batch.commit(completion: {
            error in
            completion(error == nil)
        })
        
    }
    
    //MARK: is a user following
    
    func isFollowing(currentUser: String, targetUser: String, completion: @escaping(Bool) -> Void) {
        
        let ref = database.collection("users").document(targetUser).collection("followers").document(currentUser)
        ref.getDocument(completion: {
            snapshot, error in
            guard let snap =  snapshot?.data(), error == nil else {
                completion(false)
                return
            }
            completion(true)
            
        })
        
    }
    
    //MARK: get followers
    
    public func getUsersFollowers(user: String, completion: @escaping([Follow], Bool) -> Void) {
        let ref = database.collection("users").document(user).collection("followers")
        ref.getDocuments(completion: {
            snapshot, error in
            guard let users = snapshot?.documents.compactMap( { Follow(with: $0.data()) }), error == nil else {
                completion([], false)
                return
            }
            completion(users, true)
        })
        
    }
    
    
    //MARK: get following
    
    public func getUsersFollowing(user: String, completion: @escaping([Follow], Bool) -> Void) {
        let ref = database.collection("users").document(user).collection("following")
        ref.getDocuments(completion: {
            snapshot, error in
            guard let users = snapshot?.documents.compactMap( { Follow(with: $0.data()) }), error == nil else {
                completion([], false)
                return
            }
            completion(users, true)
        })
        
    }
    
    //MARK: change top ten
    
    public func changeTopTen(topTenModel: TopTen, rank: String, userId: String, completion: @escaping(Bool) -> Void) {
        let ref = database.collection("users").document(userId).collection("topTen").document(rank)
        guard let topTenData = topTenModel.asDictionary() else {
            completion(false)
            return
        }
        
        ref.setData(topTenData, completion: {
            error in
            completion(error == nil)
        })
        
    }
    
    //MARK: change top five
    
    public func changeTopFive(topFiveModel: TopFive, rank: String, userId: String, completion: @escaping(Bool) -> Void) {
        let ref = database.collection("users").document(userId).collection("topFive").document(rank)
        
        guard let topFiveData = topFiveModel.asDictionary() else {
            completion(false)
            return
        }
        
        ref.setData(topFiveData, completion: {
            error in
            completion(error == nil)
        })
        
    }
    
    
    //MARK: get a users previous posts
    
    public func grabUsersLatestPost(userId: String, completion: @escaping([Post]?) -> Void) {
        let ref = database.collection("posts").whereField("posterId", isEqualTo: userId).order(by: "postedDate", descending: true).limit(to: 3)
        ref.getDocuments(completion: {
            snapshot, error in
            guard let posts = snapshot?.documents.compactMap({ Post(with: $0.data()) }), error == nil else {
                completion(nil)
                return
            }
            completion(posts)
        })
    }
    
    public func checkIfWasAnArtist(contentId: String, completion: @escaping(Bool, Bool) -> Void) {
        let ref = database.collection("content").document(contentId)
        ref.getDocument {
            snapshot, error in
            if error == nil {
                guard let data = snapshot?.data() else {
                    completion(false, false)
                    return
                }
                completion(true, false)
                
            } else {
                completion(false, true)
            }
        }
    }
    
    //MARK: report an issue
    
    public func reportAnIssue(issue: Issue, completion: @escaping(Bool) -> Void) {
        let uniqueIssueId = UUID().uuidString
        let ref = database.collection("issue").document(uniqueIssueId)
        guard let issueData = issue.asDictionary() else {
            completion(false)
            return
        }
        
        ref.setData(issueData, completion: {
            error in
            completion(error == nil)
        })
        
    }
    
    //MARK: grab recommended users
    
    public func grabRecommendedUsers(completion: @escaping([User]) -> Void) {
        let ref = database.collection("users").limit(to: 10)
        ref.getDocuments(completion: {
            snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }), error == nil else {
                completion([])
                return
            }
            completion(users)
        })
    }
    
    
    
}

