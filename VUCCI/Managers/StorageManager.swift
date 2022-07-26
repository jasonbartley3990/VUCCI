//
//  StorageManager.swift
//  VUCCI
//
//  Created by Jason bartley on 4/30/22.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    let storage = Storage.storage().reference()
    
    public func uploadProfilePicture(userId: String, data: Data?, completion: @escaping (Bool) -> Void) {
        guard let data = data else {return}
        storage.child("\(userId)/profile_picture.png").putData(data, metadata: nil) {
            _, error in
            completion(error == nil)
        }
    }
    
    public func profilePictureUrl(for userId: String, completion: @escaping (URL?) -> Void) {
        storage.child("\(userId)/profile_picture.png").downloadURL {
            url, _ in
            completion(url)
        }
    }
    
    
    public func uploadSongCoverImage(songGroupId: String, data: Data?, completion: @escaping (URL?) -> Void) {
        guard let data = data else {return}
        let ref =  storage.child("\(songGroupId)/image.png")
        ref.putData(data, metadata: nil) {
            _, error in
            ref.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    
    public func uploadSongGroupImage(songGroupId: String, data: Data?, completion: @escaping (URL?) -> Void) {
        guard let data = data else {return}
        let ref =  storage.child("\(songGroupId)/image.png")
        ref.putData(data, metadata: nil) {
            _, error in
            ref.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    
    
    public func uploadSongData(songId: String, data: Data?, completion: @escaping(URL?) -> Void) {
        guard let data = data else {return}
        let ref = storage.child("\(songId)/song.m4a")
        ref.putData(data, metadata: nil) {
            _, error in
            ref.downloadURL(completion: {
                url, _ in
                completion(url)
            })
        }
    }
    
    public func grabSongData(songId: String, completion: @escaping(Data?) -> Void) {
        storage.child("\(songId)/song.m4a").getData(maxSize: 900000000, completion: {
            data, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(data)
        })
    }
    
    public func uploadAlbumSongsData(songs: [NewSongViewModel], completion: @escaping([String]?) -> Void) {
        
        let songCount = songs.count
        
        var songUrls: [String] = []
        
        if songCount == 1 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                completion(songUrls)
            })
        }
        
        
        if songCount == 2 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    completion(songUrls)
                })
            })
        }
        
        
        if songCount == 3 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                        completion(songUrls)
                        
                    })
                })
            })
        }
        
        if songCount == 4 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            completion(songUrls)
                        })
                    })
                })
            })
        }
        
        if songCount == 5 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                completion(songUrls)
                            })
                        })
                    })
                })
            })
        }
        
        if songCount == 6 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    completion(songUrls)
                                })
                            })
                        })
                    })
                })
            })
        }
        
        
        if songCount == 7 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    [weak self] url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    
                                    
                                    let seventhSong = songs[6]
                                    self?.uploadSongData(songId: seventhSong.songId, data: seventhSong.audioData, completion: {
                                        url7 in
                                        guard let seventhUrl = url7 else {
                                            completion(nil)
                                            return
                                        }
                                        let seventhUrlString = seventhUrl.absoluteString
                                        songUrls.append(seventhUrlString)
                                        completion(songUrls)
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        
        
        if songCount == 8 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    [weak self] url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    
                                    
                                    let seventhSong = songs[6]
                                    self?.uploadSongData(songId: seventhSong.songId, data: seventhSong.audioData, completion: {
                                        [weak self] url7 in
                                        guard let seventhUrl = url7 else {
                                            completion(nil)
                                            return
                                        }
                                        let seventhUrlString = seventhUrl.absoluteString
                                        songUrls.append(seventhUrlString)
                                        
                                        
                                        let eighthSong = songs[7]
                                        self?.uploadSongData(songId: eighthSong.songId, data: eighthSong.audioData, completion: {
                                            url8 in
                                            guard let eighthUrl = url8 else {
                                                completion(nil)
                                                return
                                            }
                                            let eighthUrlString = eighthUrl.absoluteString
                                            songUrls.append(eighthUrlString)
                                            completion(songUrls)
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        
        
        if songCount == 9 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    [weak self] url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    
                                    
                                    let seventhSong = songs[6]
                                    self?.uploadSongData(songId: seventhSong.songId, data: seventhSong.audioData, completion: {
                                        [weak self] url7 in
                                        guard let seventhUrl = url7 else {
                                            completion(nil)
                                            return
                                        }
                                        let seventhUrlString = seventhUrl.absoluteString
                                        songUrls.append(seventhUrlString)
                                        
                                        
                                        let eighthSong = songs[7]
                                        self?.uploadSongData(songId: eighthSong.songId, data: eighthSong.audioData, completion: {
                                            [weak self] url8 in
                                            guard let eighthUrl = url8 else {
                                                completion(nil)
                                                return
                                            }
                                            let eighthUrlString = eighthUrl.absoluteString
                                            songUrls.append(eighthUrlString)
                                            
                                            
                                            let ninthSong = songs[8]
                                            self?.uploadSongData(songId: ninthSong.songId , data: ninthSong.audioData, completion: {
                                                url9 in
                                                guard let ninthUrl = url9 else {
                                                    completion(nil)
                                                    return
                                                }
                                                let ninthUrlString = ninthUrl.absoluteString
                                                songUrls.append(ninthUrlString)
                                                completion(songUrls)
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        
        
        if songCount == 10 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    [weak self] url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    
                                    
                                    let seventhSong = songs[6]
                                    self?.uploadSongData(songId: seventhSong.songId, data: seventhSong.audioData, completion: {
                                        [weak self] url7 in
                                        guard let seventhUrl = url7 else {
                                            completion(nil)
                                            return
                                        }
                                        let seventhUrlString = seventhUrl.absoluteString
                                        songUrls.append(seventhUrlString)
                                        
                                        
                                        let eighthSong = songs[7]
                                        self?.uploadSongData(songId: eighthSong.songId, data: eighthSong.audioData, completion: {
                                            [weak self] url8 in
                                            guard let eighthUrl = url8 else {
                                                completion(nil)
                                                return
                                            }
                                            let eighthUrlString = eighthUrl.absoluteString
                                            songUrls.append(eighthUrlString)
                                            
                                            
                                            let ninthSong = songs[8]
                                            self?.uploadSongData(songId: ninthSong.songId , data: ninthSong.audioData, completion: {
                                                [weak self] url9 in
                                                guard let ninthUrl = url9 else {
                                                    completion(nil)
                                                    return
                                                }
                                                let ninthUrlString = ninthUrl.absoluteString
                                                songUrls.append(ninthUrlString)
                                                
                                                
                                                let tenthSong = songs[9]
                                                self?.uploadSongData(songId: tenthSong.songId, data: tenthSong.audioData, completion: {
                                                    url10 in
                                                    guard let tenthUrl = url10 else {
                                                        completion(nil)
                                                        return
                                                    }
                                                    let tenthUrlString = tenthUrl.absoluteString
                                                    songUrls.append(tenthUrlString)
                                                    completion(songUrls)
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        
        
        if songCount == 11 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    [weak self] url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    
                                    
                                    let seventhSong = songs[6]
                                    self?.uploadSongData(songId: seventhSong.songId, data: seventhSong.audioData, completion: {
                                        [weak self] url7 in
                                        guard let seventhUrl = url7 else {
                                            completion(nil)
                                            return
                                        }
                                        let seventhUrlString = seventhUrl.absoluteString
                                        songUrls.append(seventhUrlString)
                                        
                                        
                                        let eighthSong = songs[7]
                                        self?.uploadSongData(songId: eighthSong.songId, data: eighthSong.audioData, completion: {
                                            [weak self] url8 in
                                            guard let eighthUrl = url8 else {
                                                completion(nil)
                                                return
                                            }
                                            let eighthUrlString = eighthUrl.absoluteString
                                            songUrls.append(eighthUrlString)
                                            
                                            
                                            let ninthSong = songs[8]
                                            self?.uploadSongData(songId: ninthSong.songId , data: ninthSong.audioData, completion: {
                                                [weak self] url9 in
                                                guard let ninthUrl = url9 else {
                                                    completion(nil)
                                                    return
                                                }
                                                let ninthUrlString = ninthUrl.absoluteString
                                                songUrls.append(ninthUrlString)
                                                
                                                
                                                let tenthSong = songs[9]
                                                self?.uploadSongData(songId: tenthSong.songId, data: tenthSong.audioData, completion: {
                                                    [weak self] url10 in
                                                    guard let tenthUrl = url10 else {
                                                        completion(nil)
                                                        return
                                                    }
                                                    let tenthUrlString = tenthUrl.absoluteString
                                                    songUrls.append(tenthUrlString)
                                                    
                                                    
                                                    let eleventhSong = songs[10]
                                                    self?.uploadSongData(songId: eleventhSong.songId, data: eleventhSong.audioData, completion: {
                                                        url11 in
                                                        guard let eleventhUrl = url11 else {
                                                            completion(nil)
                                                            return
                                                        }
                                                        let eleventhUrlString = eleventhUrl.absoluteString
                                                        songUrls.append(eleventhUrlString)
                                                        completion(songUrls)
                                                    })
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        
        
        if songCount == 12 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    [weak self] url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    
                                    
                                    let seventhSong = songs[6]
                                    self?.uploadSongData(songId: seventhSong.songId, data: seventhSong.audioData, completion: {
                                        [weak self] url7 in
                                        guard let seventhUrl = url7 else {
                                            completion(nil)
                                            return
                                        }
                                        let seventhUrlString = seventhUrl.absoluteString
                                        songUrls.append(seventhUrlString)
                                        
                                        
                                        let eighthSong = songs[7]
                                        self?.uploadSongData(songId: eighthSong.songId, data: eighthSong.audioData, completion: {
                                            [weak self] url8 in
                                            guard let eighthUrl = url8 else {
                                                completion(nil)
                                                return
                                            }
                                            let eighthUrlString = eighthUrl.absoluteString
                                            songUrls.append(eighthUrlString)
                                            
                                            
                                            let ninthSong = songs[8]
                                            self?.uploadSongData(songId: ninthSong.songId , data: ninthSong.audioData, completion: {
                                                [weak self] url9 in
                                                guard let ninthUrl = url9 else {
                                                    completion(nil)
                                                    return
                                                }
                                                let ninthUrlString = ninthUrl.absoluteString
                                                songUrls.append(ninthUrlString)
                                                
                                                
                                                let tenthSong = songs[9]
                                                self?.uploadSongData(songId: tenthSong.songId, data: tenthSong.audioData, completion: {
                                                    [weak self] url10 in
                                                    guard let tenthUrl = url10 else {
                                                        completion(nil)
                                                        return
                                                    }
                                                    let tenthUrlString = tenthUrl.absoluteString
                                                    songUrls.append(tenthUrlString)
                                                    
                                                    
                                                    let eleventhSong = songs[10]
                                                    self?.uploadSongData(songId: eleventhSong.songId, data: eleventhSong.audioData, completion: {
                                                        [weak self] url11 in
                                                        guard let eleventhUrl = url11 else {
                                                            completion(nil)
                                                            return
                                                        }
                                                        let eleventhUrlString = eleventhUrl.absoluteString
                                                        songUrls.append(eleventhUrlString)
                                                        
                                                        
                                                        let twelthSong = songs[11]
                                                        self?.uploadSongData(songId: twelthSong.songId, data: twelthSong.audioData, completion: {
                                                            url12 in
                                                            guard let twelthUrl = url12 else {
                                                                completion(nil)
                                                                return
                                                            }
                                                            let twelthUrlString = twelthUrl.absoluteString
                                                            songUrls.append(twelthUrlString)
                                                            completion(songUrls)
                                                        })
                                                    })
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        
        
        if songCount == 13 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    [weak self] url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    
                                    
                                    let seventhSong = songs[6]
                                    self?.uploadSongData(songId: seventhSong.songId, data: seventhSong.audioData, completion: {
                                        [weak self] url7 in
                                        guard let seventhUrl = url7 else {
                                            completion(nil)
                                            return
                                        }
                                        let seventhUrlString = seventhUrl.absoluteString
                                        songUrls.append(seventhUrlString)
                                        
                                        
                                        let eighthSong = songs[7]
                                        self?.uploadSongData(songId: eighthSong.songId, data: eighthSong.audioData, completion: {
                                            [weak self] url8 in
                                            guard let eighthUrl = url8 else {
                                                completion(nil)
                                                return
                                            }
                                            let eighthUrlString = eighthUrl.absoluteString
                                            songUrls.append(eighthUrlString)
                                            
                                            
                                            let ninthSong = songs[8]
                                            self?.uploadSongData(songId: ninthSong.songId , data: ninthSong.audioData, completion: {
                                                [weak self] url9 in
                                                guard let ninthUrl = url9 else {
                                                    completion(nil)
                                                    return
                                                }
                                                let ninthUrlString = ninthUrl.absoluteString
                                                songUrls.append(ninthUrlString)
                                                
                                                
                                                let tenthSong = songs[9]
                                                self?.uploadSongData(songId: tenthSong.songId, data: tenthSong.audioData, completion: {
                                                    [weak self] url10 in
                                                    guard let tenthUrl = url10 else {
                                                        completion(nil)
                                                        return
                                                    }
                                                    let tenthUrlString = tenthUrl.absoluteString
                                                    songUrls.append(tenthUrlString)
                                                    
                                                    
                                                    let eleventhSong = songs[10]
                                                    self?.uploadSongData(songId: eleventhSong.songId, data: eleventhSong.audioData, completion: {
                                                        [weak self] url11 in
                                                        guard let eleventhUrl = url11 else {
                                                            completion(nil)
                                                            return
                                                        }
                                                        let eleventhUrlString = eleventhUrl.absoluteString
                                                        songUrls.append(eleventhUrlString)
                                                        
                                                        
                                                        let twelthSong = songs[11]
                                                        self?.uploadSongData(songId: twelthSong.songId, data: twelthSong.audioData, completion: {
                                                            [weak self] url12 in
                                                            guard let twelthUrl = url12 else {
                                                                completion(nil)
                                                                return
                                                            }
                                                            let twelthUrlString = twelthUrl.absoluteString
                                                            songUrls.append(twelthUrlString)
                                                            
                                                            
                                                            let thirtenthSong = songs[12]
                                                            self?.uploadSongData(songId: thirtenthSong.songId, data: thirtenthSong.audioData, completion: {
                                                                url13 in
                                                                guard let thirtenthUrl = url13 else {
                                                                    completion(nil)
                                                                    return
                                                                }
                                                                
                                                                let thirtenthUrlString = thirtenthUrl.absoluteString
                                                                songUrls.append(thirtenthUrlString)
                                                                completion(songUrls)
                                                            })
                                                        })
                                                    })
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        
        
        if songCount == 14 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    [weak self] url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    
                                    
                                    let seventhSong = songs[6]
                                    self?.uploadSongData(songId: seventhSong.songId, data: seventhSong.audioData, completion: {
                                        [weak self] url7 in
                                        guard let seventhUrl = url7 else {
                                            completion(nil)
                                            return
                                        }
                                        let seventhUrlString = seventhUrl.absoluteString
                                        songUrls.append(seventhUrlString)
                                        
                                        
                                        let eighthSong = songs[7]
                                        self?.uploadSongData(songId: eighthSong.songId, data: eighthSong.audioData, completion: {
                                            [weak self] url8 in
                                            guard let eighthUrl = url8 else {
                                                completion(nil)
                                                return
                                            }
                                            let eighthUrlString = eighthUrl.absoluteString
                                            songUrls.append(eighthUrlString)
                                            
                                            
                                            let ninthSong = songs[8]
                                            self?.uploadSongData(songId: ninthSong.songId , data: ninthSong.audioData, completion: {
                                                [weak self] url9 in
                                                guard let ninthUrl = url9 else {
                                                    completion(nil)
                                                    return
                                                }
                                                let ninthUrlString = ninthUrl.absoluteString
                                                songUrls.append(ninthUrlString)
                                                
                                                
                                                let tenthSong = songs[9]
                                                self?.uploadSongData(songId: tenthSong.songId, data: tenthSong.audioData, completion: {
                                                    [weak self] url10 in
                                                    guard let tenthUrl = url10 else {
                                                        completion(nil)
                                                        return
                                                    }
                                                    let tenthUrlString = tenthUrl.absoluteString
                                                    songUrls.append(tenthUrlString)
                                                    
                                                    
                                                    let eleventhSong = songs[10]
                                                    self?.uploadSongData(songId: eleventhSong.songId, data: eleventhSong.audioData, completion: {
                                                        [weak self] url11 in
                                                        guard let eleventhUrl = url11 else {
                                                            completion(nil)
                                                            return
                                                        }
                                                        let eleventhUrlString = eleventhUrl.absoluteString
                                                        songUrls.append(eleventhUrlString)
                                                        
                                                        
                                                        let twelthSong = songs[11]
                                                        self?.uploadSongData(songId: twelthSong.songId, data: twelthSong.audioData, completion: {
                                                            [weak self] url12 in
                                                            guard let twelthUrl = url12 else {
                                                                completion(nil)
                                                                return
                                                            }
                                                            let twelthUrlString = twelthUrl.absoluteString
                                                            songUrls.append(twelthUrlString)
                                                            
                                                            
                                                            let thirtenthSong = songs[12]
                                                            self?.uploadSongData(songId: thirtenthSong.songId, data: thirtenthSong.audioData, completion: {
                                                                [weak self] url13 in
                                                                guard let thirtenthUrl = url13 else {
                                                                    completion(nil)
                                                                    return
                                                                }
                                                                
                                                                let thirtenthUrlString = thirtenthUrl.absoluteString
                                                                songUrls.append(thirtenthUrlString)
                                                                
                                                                
                                                                let fourtenthSong = songs[13]
                                                                self?.uploadSongData(songId: fourtenthSong.songId, data: fourtenthSong.audioData, completion: {
                                                                    url14 in
                                                                    guard let fourtenthUrl = url14 else {
                                                                        completion(nil)
                                                                        return
                                                                    }
                                                                    let fourtenthUrlString = fourtenthUrl.absoluteString
                                                                    songUrls.append(fourtenthUrlString)
                                                                    completion(songUrls)
                                                                    
                                                                })
                                                            })
                                                        })
                                                    })
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        
        
        if songCount == 15 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    [weak self] url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    
                                    
                                    let seventhSong = songs[6]
                                    self?.uploadSongData(songId: seventhSong.songId, data: seventhSong.audioData, completion: {
                                        [weak self] url7 in
                                        guard let seventhUrl = url7 else {
                                            completion(nil)
                                            return
                                        }
                                        let seventhUrlString = seventhUrl.absoluteString
                                        songUrls.append(seventhUrlString)
                                        
                                        
                                        let eighthSong = songs[7]
                                        self?.uploadSongData(songId: eighthSong.songId, data: eighthSong.audioData, completion: {
                                            [weak self] url8 in
                                            guard let eighthUrl = url8 else {
                                                completion(nil)
                                                return
                                            }
                                            let eighthUrlString = eighthUrl.absoluteString
                                            songUrls.append(eighthUrlString)
                                            
                                            
                                            let ninthSong = songs[8]
                                            self?.uploadSongData(songId: ninthSong.songId , data: ninthSong.audioData, completion: {
                                                [weak self] url9 in
                                                guard let ninthUrl = url9 else {
                                                    completion(nil)
                                                    return
                                                }
                                                let ninthUrlString = ninthUrl.absoluteString
                                                songUrls.append(ninthUrlString)
                                                
                                                
                                                let tenthSong = songs[9]
                                                self?.uploadSongData(songId: tenthSong.songId, data: tenthSong.audioData, completion: {
                                                    [weak self] url10 in
                                                    guard let tenthUrl = url10 else {
                                                        completion(nil)
                                                        return
                                                    }
                                                    let tenthUrlString = tenthUrl.absoluteString
                                                    songUrls.append(tenthUrlString)
                                                    
                                                    
                                                    let eleventhSong = songs[10]
                                                    self?.uploadSongData(songId: eleventhSong.songId, data: eleventhSong.audioData, completion: {
                                                        [weak self] url11 in
                                                        guard let eleventhUrl = url11 else {
                                                            completion(nil)
                                                            return
                                                        }
                                                        let eleventhUrlString = eleventhUrl.absoluteString
                                                        songUrls.append(eleventhUrlString)
                                                        
                                                        
                                                        let twelthSong = songs[11]
                                                        self?.uploadSongData(songId: twelthSong.songId, data: twelthSong.audioData, completion: {
                                                            [weak self] url12 in
                                                            guard let twelthUrl = url12 else {
                                                                completion(nil)
                                                                return
                                                            }
                                                            let twelthUrlString = twelthUrl.absoluteString
                                                            songUrls.append(twelthUrlString)
                                                            
                                                            
                                                            let thirtenthSong = songs[12]
                                                            self?.uploadSongData(songId: thirtenthSong.songId, data: thirtenthSong.audioData, completion: {
                                                                [weak self] url13 in
                                                                guard let thirtenthUrl = url13 else {
                                                                    completion(nil)
                                                                    return
                                                                }
                                                                
                                                                let thirtenthUrlString = thirtenthUrl.absoluteString
                                                                songUrls.append(thirtenthUrlString)
                                                                
                                                                
                                                                let fourtenthSong = songs[13]
                                                                self?.uploadSongData(songId: fourtenthSong.songId, data: fourtenthSong.audioData, completion: {
                                                                    [weak self] url14 in
                                                                    guard let fourtenthUrl = url14 else {
                                                                        completion(nil)
                                                                        return
                                                                    }
                                                                    let fourtenthUrlString = fourtenthUrl.absoluteString
                                                                    songUrls.append(fourtenthUrlString)
                                                                    
                                                                    
                                                                    let fiftenthSong = songs[14]
                                                                    self?.uploadSongData(songId: fiftenthSong.songId, data: fiftenthSong.audioData, completion: {
                                                                        url15 in
                                                                        guard let fiftenthUrl = url15 else {
                                                                            completion(nil)
                                                                            return
                                                                        }
                                                                        let fiftenthUrlString = fiftenthUrl.absoluteString
                                                                        songUrls.append(fiftenthUrlString)
                                                                        completion(songUrls)
                                                                    })
                                                                })
                                                            })
                                                        })
                                                    })
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        
        if songCount == 16 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    [weak self] url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    
                                    
                                    let seventhSong = songs[6]
                                    self?.uploadSongData(songId: seventhSong.songId, data: seventhSong.audioData, completion: {
                                        [weak self] url7 in
                                        guard let seventhUrl = url7 else {
                                            completion(nil)
                                            return
                                        }
                                        let seventhUrlString = seventhUrl.absoluteString
                                        songUrls.append(seventhUrlString)
                                        
                                        
                                        let eighthSong = songs[7]
                                        self?.uploadSongData(songId: eighthSong.songId, data: eighthSong.audioData, completion: {
                                            [weak self] url8 in
                                            guard let eighthUrl = url8 else {
                                                completion(nil)
                                                return
                                            }
                                            let eighthUrlString = eighthUrl.absoluteString
                                            songUrls.append(eighthUrlString)
                                            
                                            
                                            let ninthSong = songs[8]
                                            self?.uploadSongData(songId: ninthSong.songId , data: ninthSong.audioData, completion: {
                                                [weak self] url9 in
                                                guard let ninthUrl = url9 else {
                                                    completion(nil)
                                                    return
                                                }
                                                let ninthUrlString = ninthUrl.absoluteString
                                                songUrls.append(ninthUrlString)
                                                
                                                
                                                let tenthSong = songs[9]
                                                self?.uploadSongData(songId: tenthSong.songId, data: tenthSong.audioData, completion: {
                                                    [weak self] url10 in
                                                    guard let tenthUrl = url10 else {
                                                        completion(nil)
                                                        return
                                                    }
                                                    let tenthUrlString = tenthUrl.absoluteString
                                                    songUrls.append(tenthUrlString)
                                                    
                                                    
                                                    let eleventhSong = songs[10]
                                                    self?.uploadSongData(songId: eleventhSong.songId, data: eleventhSong.audioData, completion: {
                                                        [weak self] url11 in
                                                        guard let eleventhUrl = url11 else {
                                                            completion(nil)
                                                            return
                                                        }
                                                        let eleventhUrlString = eleventhUrl.absoluteString
                                                        songUrls.append(eleventhUrlString)
                                                        
                                                        
                                                        let twelthSong = songs[11]
                                                        self?.uploadSongData(songId: twelthSong.songId, data: twelthSong.audioData, completion: {
                                                            [weak self] url12 in
                                                            guard let twelthUrl = url12 else {
                                                                completion(nil)
                                                                return
                                                            }
                                                            let twelthUrlString = twelthUrl.absoluteString
                                                            songUrls.append(twelthUrlString)
                                                            
                                                            
                                                            let thirtenthSong = songs[12]
                                                            self?.uploadSongData(songId: thirtenthSong.songId, data: thirtenthSong.audioData, completion: {
                                                                [weak self] url13 in
                                                                guard let thirtenthUrl = url13 else {
                                                                    completion(nil)
                                                                    return
                                                                }
                                                                
                                                                let thirtenthUrlString = thirtenthUrl.absoluteString
                                                                songUrls.append(thirtenthUrlString)
                                                                
                                                                
                                                                let fourtenthSong = songs[13]
                                                                self?.uploadSongData(songId: fourtenthSong.songId, data: fourtenthSong.audioData, completion: {
                                                                    [weak self] url14 in
                                                                    guard let fourtenthUrl = url14 else {
                                                                        completion(nil)
                                                                        return
                                                                    }
                                                                    let fourtenthUrlString = fourtenthUrl.absoluteString
                                                                    songUrls.append(fourtenthUrlString)
                                                                    
                                                                    
                                                                    let fiftenthSong = songs[14]
                                                                    self?.uploadSongData(songId: fiftenthSong.songId, data: fiftenthSong.audioData, completion: {
                                                                        [weak self] url15 in
                                                                        guard let fiftenthUrl = url15 else {
                                                                            completion(nil)
                                                                            return
                                                                        }
                                                                        let fiftenthUrlString = fiftenthUrl.absoluteString
                                                                        songUrls.append(fiftenthUrlString)
                                                                        
                                                                        let sixtenthSong = songs[15]
                                                                        self?.uploadSongData(songId: sixtenthSong.songId, data: sixtenthSong.audioData, completion: {
                                                                            url16 in
                                                                            guard let sixtenthUrl = url16 else {
                                                                                completion(nil)
                                                                                return
                                                                            }
                                                                            let sixtenthUrlString = sixtenthUrl.absoluteString
                                                                            songUrls.append(sixtenthUrlString)
                                                                            completion(songUrls)
                                                                        })
                                                                    })
                                                                })
                                                            })
                                                        })
                                                    })
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        
        
        if songCount == 17 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    [weak self] url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    
                                    
                                    let seventhSong = songs[6]
                                    self?.uploadSongData(songId: seventhSong.songId, data: seventhSong.audioData, completion: {
                                        [weak self] url7 in
                                        guard let seventhUrl = url7 else {
                                            completion(nil)
                                            return
                                        }
                                        let seventhUrlString = seventhUrl.absoluteString
                                        songUrls.append(seventhUrlString)
                                        
                                        
                                        let eighthSong = songs[7]
                                        self?.uploadSongData(songId: eighthSong.songId, data: eighthSong.audioData, completion: {
                                            [weak self] url8 in
                                            guard let eighthUrl = url8 else {
                                                completion(nil)
                                                return
                                            }
                                            let eighthUrlString = eighthUrl.absoluteString
                                            songUrls.append(eighthUrlString)
                                            
                                            
                                            let ninthSong = songs[8]
                                            self?.uploadSongData(songId: ninthSong.songId , data: ninthSong.audioData, completion: {
                                                [weak self] url9 in
                                                guard let ninthUrl = url9 else {
                                                    completion(nil)
                                                    return
                                                }
                                                let ninthUrlString = ninthUrl.absoluteString
                                                songUrls.append(ninthUrlString)
                                                
                                                
                                                let tenthSong = songs[9]
                                                self?.uploadSongData(songId: tenthSong.songId, data: tenthSong.audioData, completion: {
                                                    [weak self] url10 in
                                                    guard let tenthUrl = url10 else {
                                                        completion(nil)
                                                        return
                                                    }
                                                    let tenthUrlString = tenthUrl.absoluteString
                                                    songUrls.append(tenthUrlString)
                                                    
                                                    
                                                    let eleventhSong = songs[10]
                                                    self?.uploadSongData(songId: eleventhSong.songId, data: eleventhSong.audioData, completion: {
                                                        [weak self] url11 in
                                                        guard let eleventhUrl = url11 else {
                                                            completion(nil)
                                                            return
                                                        }
                                                        let eleventhUrlString = eleventhUrl.absoluteString
                                                        songUrls.append(eleventhUrlString)
                                                        
                                                        
                                                        let twelthSong = songs[11]
                                                        self?.uploadSongData(songId: twelthSong.songId, data: twelthSong.audioData, completion: {
                                                            [weak self] url12 in
                                                            guard let twelthUrl = url12 else {
                                                                completion(nil)
                                                                return
                                                            }
                                                            let twelthUrlString = twelthUrl.absoluteString
                                                            songUrls.append(twelthUrlString)
                                                            
                                                            
                                                            let thirtenthSong = songs[12]
                                                            self?.uploadSongData(songId: thirtenthSong.songId, data: thirtenthSong.audioData, completion: {
                                                                [weak self] url13 in
                                                                guard let thirtenthUrl = url13 else {
                                                                    completion(nil)
                                                                    return
                                                                }
                                                                
                                                                let thirtenthUrlString = thirtenthUrl.absoluteString
                                                                songUrls.append(thirtenthUrlString)
                                                                
                                                                
                                                                let fourtenthSong = songs[13]
                                                                self?.uploadSongData(songId: fourtenthSong.songId, data: fourtenthSong.audioData, completion: {
                                                                    [weak self] url14 in
                                                                    guard let fourtenthUrl = url14 else {
                                                                        completion(nil)
                                                                        return
                                                                    }
                                                                    let fourtenthUrlString = fourtenthUrl.absoluteString
                                                                    songUrls.append(fourtenthUrlString)
                                                                    
                                                                    
                                                                    let fiftenthSong = songs[14]
                                                                    self?.uploadSongData(songId: fiftenthSong.songId, data: fiftenthSong.audioData, completion: {
                                                                        [weak self] url15 in
                                                                        guard let fiftenthUrl = url15 else {
                                                                            completion(nil)
                                                                            return
                                                                        }
                                                                        let fiftenthUrlString = fiftenthUrl.absoluteString
                                                                        songUrls.append(fiftenthUrlString)
                                                                        
                                                                        let sixtenthSong = songs[15]
                                                                        self?.uploadSongData(songId: sixtenthSong.songId, data: sixtenthSong.audioData, completion: {
                                                                            [weak self] url16 in
                                                                            guard let sixtenthUrl = url16 else {
                                                                                completion(nil)
                                                                                return
                                                                            }
                                                                            let sixtenthUrlString = sixtenthUrl.absoluteString
                                                                            songUrls.append(sixtenthUrlString)
                                                                            
                                                                            
                                                                            let sevententhSong = songs[16]
                                                                            self?.uploadSongData(songId: sevententhSong.songId, data: sevententhSong.audioData, completion: {
                                                                                url17 in
                                                                                guard let sevententhUrl = url17 else {
                                                                                    completion(nil)
                                                                                    return
                                                                                }
                                                                                let sevententhUrlString = sevententhUrl.absoluteString
                                                                                songUrls.append(sevententhUrlString)
                                                                                completion(songUrls)
                                                                            })
                                                                            
                                                                        })
                                                                    })
                                                                })
                                                            })
                                                        })
                                                    })
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        
        
        if songCount == 18 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    [weak self] url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    
                                    
                                    let seventhSong = songs[6]
                                    self?.uploadSongData(songId: seventhSong.songId, data: seventhSong.audioData, completion: {
                                        [weak self] url7 in
                                        guard let seventhUrl = url7 else {
                                            completion(nil)
                                            return
                                        }
                                        let seventhUrlString = seventhUrl.absoluteString
                                        songUrls.append(seventhUrlString)
                                        
                                        
                                        let eighthSong = songs[7]
                                        self?.uploadSongData(songId: eighthSong.songId, data: eighthSong.audioData, completion: {
                                            [weak self] url8 in
                                            guard let eighthUrl = url8 else {
                                                completion(nil)
                                                return
                                            }
                                            let eighthUrlString = eighthUrl.absoluteString
                                            songUrls.append(eighthUrlString)
                                            
                                            
                                            let ninthSong = songs[8]
                                            self?.uploadSongData(songId: ninthSong.songId , data: ninthSong.audioData, completion: {
                                                [weak self] url9 in
                                                guard let ninthUrl = url9 else {
                                                    completion(nil)
                                                    return
                                                }
                                                let ninthUrlString = ninthUrl.absoluteString
                                                songUrls.append(ninthUrlString)
                                                
                                                
                                                let tenthSong = songs[9]
                                                self?.uploadSongData(songId: tenthSong.songId, data: tenthSong.audioData, completion: {
                                                    [weak self] url10 in
                                                    guard let tenthUrl = url10 else {
                                                        completion(nil)
                                                        return
                                                    }
                                                    let tenthUrlString = tenthUrl.absoluteString
                                                    songUrls.append(tenthUrlString)
                                                    
                                                    
                                                    let eleventhSong = songs[10]
                                                    self?.uploadSongData(songId: eleventhSong.songId, data: eleventhSong.audioData, completion: {
                                                        [weak self] url11 in
                                                        guard let eleventhUrl = url11 else {
                                                            completion(nil)
                                                            return
                                                        }
                                                        let eleventhUrlString = eleventhUrl.absoluteString
                                                        songUrls.append(eleventhUrlString)
                                                        
                                                        
                                                        let twelthSong = songs[11]
                                                        self?.uploadSongData(songId: twelthSong.songId, data: twelthSong.audioData, completion: {
                                                            [weak self] url12 in
                                                            guard let twelthUrl = url12 else {
                                                                completion(nil)
                                                                return
                                                            }
                                                            let twelthUrlString = twelthUrl.absoluteString
                                                            songUrls.append(twelthUrlString)
                                                            
                                                            
                                                            let thirtenthSong = songs[12]
                                                            self?.uploadSongData(songId: thirtenthSong.songId, data: thirtenthSong.audioData, completion: {
                                                                [weak self] url13 in
                                                                guard let thirtenthUrl = url13 else {
                                                                    completion(nil)
                                                                    return
                                                                }
                                                                
                                                                let thirtenthUrlString = thirtenthUrl.absoluteString
                                                                songUrls.append(thirtenthUrlString)
                                                                
                                                                
                                                                let fourtenthSong = songs[13]
                                                                self?.uploadSongData(songId: fourtenthSong.songId, data: fourtenthSong.audioData, completion: {
                                                                    [weak self] url14 in
                                                                    guard let fourtenthUrl = url14 else {
                                                                        completion(nil)
                                                                        return
                                                                    }
                                                                    let fourtenthUrlString = fourtenthUrl.absoluteString
                                                                    songUrls.append(fourtenthUrlString)
                                                                    
                                                                    
                                                                    let fiftenthSong = songs[14]
                                                                    self?.uploadSongData(songId: fiftenthSong.songId, data: fiftenthSong.audioData, completion: {
                                                                        [weak self] url15 in
                                                                        guard let fiftenthUrl = url15 else {
                                                                            completion(nil)
                                                                            return
                                                                        }
                                                                        let fiftenthUrlString = fiftenthUrl.absoluteString
                                                                        songUrls.append(fiftenthUrlString)
                                                                        
                                                                        let sixtenthSong = songs[15]
                                                                        self?.uploadSongData(songId: sixtenthSong.songId, data: sixtenthSong.audioData, completion: {
                                                                            [weak self] url16 in
                                                                            guard let sixtenthUrl = url16 else {
                                                                                completion(nil)
                                                                                return
                                                                            }
                                                                            let sixtenthUrlString = sixtenthUrl.absoluteString
                                                                            songUrls.append(sixtenthUrlString)
                                                                            
                                                                            
                                                                            let sevententhSong = songs[16]
                                                                            self?.uploadSongData(songId: sevententhSong.songId, data: sevententhSong.audioData, completion: {
                                                                                [weak self] url17 in
                                                                                guard let sevententhUrl = url17 else {
                                                                                    completion(nil)
                                                                                    return
                                                                                }
                                                                                let sevententhUrlString = sevententhUrl.absoluteString
                                                                                songUrls.append(sevententhUrlString)
                                                                                
                                                                                
                                                                                let eightenthSong = songs[17]
                                                                                self?.uploadSongData(songId: eightenthSong.songId, data: eightenthSong.audioData, completion: {
                                                                                    url18 in
                                                                                    guard let eigtenthUrl = url18 else {
                                                                                        completion(nil)
                                                                                        return
                                                                                    }
                                                                                    let eigtenthUrlString = eigtenthUrl.absoluteString
                                                                                    songUrls.append(eigtenthUrlString)
                                                                                    completion(songUrls)
                                                                                })
                                                                            })
                                                                        })
                                                                    })
                                                                })
                                                            })
                                                        })
                                                    })
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        
        if songCount == 19 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    [weak self] url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    
                                    
                                    let seventhSong = songs[6]
                                    self?.uploadSongData(songId: seventhSong.songId, data: seventhSong.audioData, completion: {
                                        [weak self] url7 in
                                        guard let seventhUrl = url7 else {
                                            completion(nil)
                                            return
                                        }
                                        let seventhUrlString = seventhUrl.absoluteString
                                        songUrls.append(seventhUrlString)
                                        
                                        
                                        let eighthSong = songs[7]
                                        self?.uploadSongData(songId: eighthSong.songId, data: eighthSong.audioData, completion: {
                                            [weak self] url8 in
                                            guard let eighthUrl = url8 else {
                                                completion(nil)
                                                return
                                            }
                                            let eighthUrlString = eighthUrl.absoluteString
                                            songUrls.append(eighthUrlString)
                                            
                                            
                                            let ninthSong = songs[8]
                                            self?.uploadSongData(songId: ninthSong.songId , data: ninthSong.audioData, completion: {
                                                [weak self] url9 in
                                                guard let ninthUrl = url9 else {
                                                    completion(nil)
                                                    return
                                                }
                                                let ninthUrlString = ninthUrl.absoluteString
                                                songUrls.append(ninthUrlString)
                                                
                                                
                                                let tenthSong = songs[9]
                                                self?.uploadSongData(songId: tenthSong.songId, data: tenthSong.audioData, completion: {
                                                    [weak self] url10 in
                                                    guard let tenthUrl = url10 else {
                                                        completion(nil)
                                                        return
                                                    }
                                                    let tenthUrlString = tenthUrl.absoluteString
                                                    songUrls.append(tenthUrlString)
                                                    
                                                    
                                                    let eleventhSong = songs[10]
                                                    self?.uploadSongData(songId: eleventhSong.songId, data: eleventhSong.audioData, completion: {
                                                        [weak self] url11 in
                                                        guard let eleventhUrl = url11 else {
                                                            completion(nil)
                                                            return
                                                        }
                                                        let eleventhUrlString = eleventhUrl.absoluteString
                                                        songUrls.append(eleventhUrlString)
                                                        
                                                        
                                                        let twelthSong = songs[11]
                                                        self?.uploadSongData(songId: twelthSong.songId, data: twelthSong.audioData, completion: {
                                                            [weak self] url12 in
                                                            guard let twelthUrl = url12 else {
                                                                completion(nil)
                                                                return
                                                            }
                                                            let twelthUrlString = twelthUrl.absoluteString
                                                            songUrls.append(twelthUrlString)
                                                            
                                                            
                                                            let thirtenthSong = songs[12]
                                                            self?.uploadSongData(songId: thirtenthSong.songId, data: thirtenthSong.audioData, completion: {
                                                                [weak self] url13 in
                                                                guard let thirtenthUrl = url13 else {
                                                                    completion(nil)
                                                                    return
                                                                }
                                                                
                                                                let thirtenthUrlString = thirtenthUrl.absoluteString
                                                                songUrls.append(thirtenthUrlString)
                                                                
                                                                
                                                                let fourtenthSong = songs[13]
                                                                self?.uploadSongData(songId: fourtenthSong.songId, data: fourtenthSong.audioData, completion: {
                                                                    [weak self] url14 in
                                                                    guard let fourtenthUrl = url14 else {
                                                                        completion(nil)
                                                                        return
                                                                    }
                                                                    let fourtenthUrlString = fourtenthUrl.absoluteString
                                                                    songUrls.append(fourtenthUrlString)
                                                                    
                                                                    
                                                                    let fiftenthSong = songs[14]
                                                                    self?.uploadSongData(songId: fiftenthSong.songId, data: fiftenthSong.audioData, completion: {
                                                                        [weak self] url15 in
                                                                        guard let fiftenthUrl = url15 else {
                                                                            completion(nil)
                                                                            return
                                                                        }
                                                                        let fiftenthUrlString = fiftenthUrl.absoluteString
                                                                        songUrls.append(fiftenthUrlString)
                                                                        
                                                                        let sixtenthSong = songs[15]
                                                                        self?.uploadSongData(songId: sixtenthSong.songId, data: sixtenthSong.audioData, completion: {
                                                                            [weak self] url16 in
                                                                            guard let sixtenthUrl = url16 else {
                                                                                completion(nil)
                                                                                return
                                                                            }
                                                                            let sixtenthUrlString = sixtenthUrl.absoluteString
                                                                            songUrls.append(sixtenthUrlString)
                                                                            
                                                                            
                                                                            let sevententhSong = songs[16]
                                                                            self?.uploadSongData(songId: sevententhSong.songId, data: sevententhSong.audioData, completion: {
                                                                                [weak self] url17 in
                                                                                guard let sevententhUrl = url17 else {
                                                                                    completion(nil)
                                                                                    return
                                                                                }
                                                                                let sevententhUrlString = sevententhUrl.absoluteString
                                                                                songUrls.append(sevententhUrlString)
                                                                                
                                                                                
                                                                                let eightenthSong = songs[17]
                                                                                self?.uploadSongData(songId: eightenthSong.songId, data: eightenthSong.audioData, completion: {
                                                                                    [weak self] url18 in
                                                                                    guard let eigtenthUrl = url18 else {
                                                                                        completion(nil)
                                                                                        return
                                                                                    }
                                                                                    let eigtenthUrlString = eigtenthUrl.absoluteString
                                                                                    songUrls.append(eigtenthUrlString)
                                                                                    
                                                                                    
                                                                                    let ninetenthSong = songs[18]
                                                                                    self?.uploadSongData(songId: ninetenthSong.songId, data: ninetenthSong.audioData, completion: {
                                                                                        url19 in
                                                                                        guard let ninetenthUrl = url19 else {
                                                                                            completion(nil)
                                                                                            return
                                                                                        }
                                                                                        let ninetenthUrlString = ninetenthUrl.absoluteString
                                                                                        songUrls.append(ninetenthUrlString)
                                                                                        completion(songUrls)
                                                                                    })
                                                                                    
                                                                                })
                                                                            })
                                                                        })
                                                                    })
                                                                })
                                                            })
                                                        })
                                                    })
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        
        
        
        if songCount == 20 {
            let firstSong = songs[0]
            self.uploadSongData(songId: firstSong.songId , data: firstSong.audioData, completion: {
                [weak self] url in
                guard let firstUrl = url else {
                    completion(nil)
                    return
                }
                let firstUrlString = firstUrl.absoluteString
                songUrls.append(firstUrlString)
                
                
                let secondSong = songs[1]
                self?.uploadSongData(songId: secondSong.songId, data: secondSong.audioData, completion: {
                    [weak self] url2 in
                    guard let secondUrl = url2 else {
                        completion(nil)
                        return
                    }
                    let secondUrlSring = secondUrl.absoluteString
                    songUrls.append(secondUrlSring)
                    
                    
                    let thirdSong = songs[2]
                    self?.uploadSongData(songId: thirdSong.songId, data: thirdSong.audioData, completion: {
                        [weak self] url3 in
                        guard let thirdUrl = url3 else {
                            completion(nil)
                            return
                        }
                        let thirdUrlString = thirdUrl.absoluteString
                        songUrls.append(thirdUrlString)
                       
                        
                        let fourthSong = songs[3]
                        self?.uploadSongData(songId: fourthSong.songId, data: fourthSong.audioData, completion: {
                            [weak self] url4 in
                            guard let fourthUrl = url4 else {
                                completion(nil)
                                return
                            }
                            let fourthUrlString = fourthUrl.absoluteString
                            songUrls.append(fourthUrlString)
                            
                            let fifthSong = songs[4]
                            self?.uploadSongData(songId: fifthSong.songId, data: fifthSong.audioData, completion: {
                                [weak self] url5 in
                                guard let fifthUrl = url5 else {
                                    completion(nil)
                                    return
                                }
                                let fifthUrlString = fifthUrl.absoluteString
                                songUrls.append(fifthUrlString)
                                
                                
                                let sixthSong = songs[5]
                                self?.uploadSongData(songId: sixthSong.songId, data: sixthSong.audioData, completion: {
                                    [weak self] url6 in
                                    guard let sixthUrl = url6 else {
                                        completion(nil)
                                        return
                                    }
                                    let sixthUrlString = sixthUrl.absoluteString
                                    songUrls.append(sixthUrlString)
                                    
                                    
                                    let seventhSong = songs[6]
                                    self?.uploadSongData(songId: seventhSong.songId, data: seventhSong.audioData, completion: {
                                        [weak self] url7 in
                                        guard let seventhUrl = url7 else {
                                            completion(nil)
                                            return
                                        }
                                        let seventhUrlString = seventhUrl.absoluteString
                                        songUrls.append(seventhUrlString)
                                        
                                        
                                        let eighthSong = songs[7]
                                        self?.uploadSongData(songId: eighthSong.songId, data: eighthSong.audioData, completion: {
                                            [weak self] url8 in
                                            guard let eighthUrl = url8 else {
                                                completion(nil)
                                                return
                                            }
                                            let eighthUrlString = eighthUrl.absoluteString
                                            songUrls.append(eighthUrlString)
                                            
                                            
                                            let ninthSong = songs[8]
                                            self?.uploadSongData(songId: ninthSong.songId , data: ninthSong.audioData, completion: {
                                                [weak self] url9 in
                                                guard let ninthUrl = url9 else {
                                                    completion(nil)
                                                    return
                                                }
                                                let ninthUrlString = ninthUrl.absoluteString
                                                songUrls.append(ninthUrlString)
                                                
                                                
                                                let tenthSong = songs[9]
                                                self?.uploadSongData(songId: tenthSong.songId, data: tenthSong.audioData, completion: {
                                                    [weak self] url10 in
                                                    guard let tenthUrl = url10 else {
                                                        completion(nil)
                                                        return
                                                    }
                                                    let tenthUrlString = tenthUrl.absoluteString
                                                    songUrls.append(tenthUrlString)
                                                    
                                                    
                                                    let eleventhSong = songs[10]
                                                    self?.uploadSongData(songId: eleventhSong.songId, data: eleventhSong.audioData, completion: {
                                                        [weak self] url11 in
                                                        guard let eleventhUrl = url11 else {
                                                            completion(nil)
                                                            return
                                                        }
                                                        let eleventhUrlString = eleventhUrl.absoluteString
                                                        songUrls.append(eleventhUrlString)
                                                        
                                                        
                                                        let twelthSong = songs[11]
                                                        self?.uploadSongData(songId: twelthSong.songId, data: twelthSong.audioData, completion: {
                                                            [weak self] url12 in
                                                            guard let twelthUrl = url12 else {
                                                                completion(nil)
                                                                return
                                                            }
                                                            let twelthUrlString = twelthUrl.absoluteString
                                                            songUrls.append(twelthUrlString)
                                                            
                                                            
                                                            let thirtenthSong = songs[12]
                                                            self?.uploadSongData(songId: thirtenthSong.songId, data: thirtenthSong.audioData, completion: {
                                                                [weak self] url13 in
                                                                guard let thirtenthUrl = url13 else {
                                                                    completion(nil)
                                                                    return
                                                                }
                                                                
                                                                let thirtenthUrlString = thirtenthUrl.absoluteString
                                                                songUrls.append(thirtenthUrlString)
                                                                
                                                                
                                                                let fourtenthSong = songs[13]
                                                                self?.uploadSongData(songId: fourtenthSong.songId, data: fourtenthSong.audioData, completion: {
                                                                    [weak self] url14 in
                                                                    guard let fourtenthUrl = url14 else {
                                                                        completion(nil)
                                                                        return
                                                                    }
                                                                    let fourtenthUrlString = fourtenthUrl.absoluteString
                                                                    songUrls.append(fourtenthUrlString)
                                                                    
                                                                    
                                                                    let fiftenthSong = songs[14]
                                                                    self?.uploadSongData(songId: fiftenthSong.songId, data: fiftenthSong.audioData, completion: {
                                                                        [weak self] url15 in
                                                                        guard let fiftenthUrl = url15 else {
                                                                            completion(nil)
                                                                            return
                                                                        }
                                                                        let fiftenthUrlString = fiftenthUrl.absoluteString
                                                                        songUrls.append(fiftenthUrlString)
                                                                        
                                                                        let sixtenthSong = songs[15]
                                                                        self?.uploadSongData(songId: sixtenthSong.songId, data: sixtenthSong.audioData, completion: {
                                                                            [weak self] url16 in
                                                                            guard let sixtenthUrl = url16 else {
                                                                                completion(nil)
                                                                                return
                                                                            }
                                                                            let sixtenthUrlString = sixtenthUrl.absoluteString
                                                                            songUrls.append(sixtenthUrlString)
                                                                            
                                                                            
                                                                            let sevententhSong = songs[16]
                                                                            self?.uploadSongData(songId: sevententhSong.songId, data: sevententhSong.audioData, completion: {
                                                                                [weak self] url17 in
                                                                                guard let sevententhUrl = url17 else {
                                                                                    completion(nil)
                                                                                    return
                                                                                }
                                                                                let sevententhUrlString = sevententhUrl.absoluteString
                                                                                songUrls.append(sevententhUrlString)
                                                                                
                                                                                
                                                                                let eightenthSong = songs[17]
                                                                                self?.uploadSongData(songId: eightenthSong.songId, data: eightenthSong.audioData, completion: {
                                                                                    [weak self] url18 in
                                                                                    guard let eigtenthUrl = url18 else {
                                                                                        completion(nil)
                                                                                        return
                                                                                    }
                                                                                    let eigtenthUrlString = eigtenthUrl.absoluteString
                                                                                    songUrls.append(eigtenthUrlString)
                                                                                    
                                                                                    
                                                                                    let ninetenthSong = songs[18]
                                                                                    self?.uploadSongData(songId: ninetenthSong.songId, data: ninetenthSong.audioData, completion: {
                                                                                        [weak self] url19 in
                                                                                        guard let ninetenthUrl = url19 else {
                                                                                            completion(nil)
                                                                                            return
                                                                                        }
                                                                                        let ninetenthUrlString = ninetenthUrl.absoluteString
                                                                                        songUrls.append(ninetenthUrlString)
                                                                                        
                                                                                        
                                                                                        let twentySong = songs[19]
                                                                                        self?.uploadSongData(songId: twentySong.songId, data: twentySong.audioData, completion: {
                                                                                            url20 in
                                                                                            guard let twentyUrl = url20 else {
                                                                                                completion(nil)
                                                                                                return
                                                                                            }
                                                                                            let twentyUrlString = twentyUrl.absoluteString
                                                                                            songUrls.append(twentyUrlString)
                                                                                            completion(songUrls)
                                                                                        })
                                                                                    })
                                                                                })
                                                                            })
                                                                        })
                                                                    })
                                                                })
                                                            })
                                                        })
                                                    })
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        
        
    }
    
}
