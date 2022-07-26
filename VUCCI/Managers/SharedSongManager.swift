//
//  SharedSongManager.swift
//  VUCCI
//
//  Created by Jason bartley on 4/18/22.
//

import Foundation
import AVFoundation
import UIKit
import MediaPlayer

class SharedSongManager: UIViewController, AVAudioPlayerDelegate {
    
    static let shared = SharedSongManager()
    
    var playing: Bool = false
    
    var isLiked: Bool = false
    
    public var player: AVAudioPlayer?
    
    public var wasQueued: Bool = false
    
    public var currentSong: Content? = nil {
        didSet {
            if !wasQueued  {
                guard let contentId = currentSong?.contentId else {
                    return
                }
                
                guard let userId = InformationManager.shared.getUserId() else {
                    return
                }
                
                NotificationCenter.default.post(name: NSNotification.Name("loadingSong"), object: nil)
                
                DispatchQueue.global(qos: .userInitiated).async {
                    StorageManager.shared.grabSongData(songId: contentId, completion: {
                    [weak self] data in
                        self?.currentSongData = data
                
                        DatabaseManager.shared.isALikedSong(user: userId, songId: contentId, completion: {
                            [weak self] liked in
                            self?.isLiked = liked
                            NotificationCenter.default.post(name: NSNotification.Name("didChangeSong"), object: nil)
                            self?.startMusic()
                        })
                    })
                }
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("didChangeSong"), object: nil)
            }
        }
    }
    
    public var currentSongData: Data?
    
    public var queueToPrepare: [Content] = []
    
    public var musicQueue: [Content] = []
    
    public var playedMusicQueue: [Content] = []
    
    public var musicQueueData: [Data] = []

    public var playedMusicQueueData: [Data] = []
    
    public var musicQueueIsLiked: [Bool] = []
    
    public var playedMusicQueueIsLiked: [Bool] = []
    
    public var currentQueuePosition: Int = 0
    
    public var imageViewImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private init() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startMusic() {
         do {
             try AVAudioSession.sharedInstance().setMode(.default)
             try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
             try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
             
             guard let data = self.currentSongData else {return}
             
             player = try AVAudioPlayer(data: data)
             
             guard let player = player else {
                 return
             }
             
             player.delegate = self
             player.play()
             setupNowPlaying()
             SharedSongManager.shared.playing = true
         
         } catch {
             currentSong = nil
             NotificationCenter.default.post(name: NSNotification.Name("didChangeSong"), object: nil)
         }
     }
    
    public func stopMusic() {
        player?.stop()
        self.playing = false
    }
    
    public func pauseMusic() {
        player?.pause()
        self.playing = false
    }
    
    public func playMusic() {
        player?.play()
        self.playing = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didTapNext()
    }
    
    public func setUpQueue() {
        self.musicQueue.removeAll()
        self.playedMusicQueue.removeAll()
        self.musicQueueData.removeAll()
        self.playedMusicQueueData.removeAll()
        self.musicQueueIsLiked.removeAll()
        self.playedMusicQueueIsLiked.removeAll()
    
        grabNextSongData()
    }
    
    private func grabNextSongData() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let queueToPrepare = self?.queueToPrepare else {return}
            
            if !queueToPrepare.isEmpty {
                guard let song = self?.queueToPrepare[0] else {
                    return
                }
        
                self?.musicQueue.append(song)

                guard let userId = UserDefaults.standard.string(forKey: "userId") else {
                    return
                }

                StorageManager.shared.grabSongData(songId: song.contentId, completion: {
                    [weak self] data in
                    guard let data = data else {return}
                    self?.musicQueueData.append(data)

                    DatabaseManager.shared.isALikedSong(user: userId, songId: song.contentId, completion: {
                        [weak self] liked in
                        self?.musicQueueIsLiked.append(liked)
                        self?.queueToPrepare.remove(at: 0)
                        self?.grabNextSongData()
                    })
                })
            }
        }
    }
    
    public func didTapNext() {
        guard !musicQueue.isEmpty else {
            self.startMusic()
            return
        }
        
        if currentQueuePosition < (musicQueue.count - 1) {
            guard ((currentQueuePosition + 1) <= (musicQueueData.count - 1)), ((currentQueuePosition + 1) <= (musicQueue.count - 1)),((currentQueuePosition + 1) <= (musicQueueIsLiked.count - 1)) else {
                NotificationCenter.default.post(name: NSNotification.Name("badConnection"), object: nil)
                return
            }
            
            currentQueuePosition += 1
            
            self.wasQueued = true
            self.currentSong = musicQueue[currentQueuePosition]
            self.currentSongData = musicQueueData[currentQueuePosition]
            self.isLiked = musicQueueIsLiked[currentQueuePosition]
            
            startMusic()
            
        } else {
            currentQueuePosition = 0
            
            guard musicQueue.count != 0, musicQueueData.count != 0, musicQueueIsLiked.count != 0 else {return}
            
            self.wasQueued = true
            self.currentSong = musicQueue[currentQueuePosition]
            self.currentSongData = musicQueueData[currentQueuePosition]
            self.isLiked = musicQueueIsLiked[currentQueuePosition]
        
            startMusic()
        }
    }
    
    public func didTapPrevious() {
        guard !musicQueue.isEmpty else {
            startMusic()
            return
        }
        if let currentTime = self.player?.currentTime {
            if currentTime > 2.0 {
                self.startMusic()
            } else {
                guard currentQueuePosition > 0 else {return}
                currentQueuePosition -= 1
                
                self.wasQueued = true
                self.currentSong = musicQueue[currentQueuePosition]
                self.currentSongData = musicQueueData[currentQueuePosition]
                self.isLiked = musicQueueIsLiked[currentQueuePosition]
                
                startMusic()
            }
            
        } else {
            guard currentQueuePosition > 0 else {return}
            currentQueuePosition -= 1
            
            self.wasQueued = true
            self.currentSong = musicQueue[currentQueuePosition]
            self.currentSongData = musicQueueData[currentQueuePosition]
            self.isLiked = musicQueueIsLiked[currentQueuePosition]
            
            startMusic()
        }
    }
    
    
    func setupNowPlaying() {
        // Define Now Playing Info
        guard let currentSong = SharedSongManager.shared.currentSong else {
            return
        }
    
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentSong.name
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = currentSong.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        nowPlayingInfo[MPNowPlayingInfoCollectionIdentifier] = currentSong.ArtistName
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        MPNowPlayingInfoCenter.default().playbackState = .playing
    }
}
