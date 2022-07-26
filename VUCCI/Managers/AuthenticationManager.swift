//
//  AuthenticationManager.swift
//  VUCCI
//
//  Created by Jason bartley on 4/29/22.
//

import Foundation
import Firebase
import FirebaseAuth
import MediaPlayer

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() {}
    
    let auth = Auth.auth()
    
    enum AuthError: Error {
        case newUserCreation
        case signInFailed
    }
    
    enum ChangeUsernameError {
        case wrongPassword
        case databaseIssue
    }
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    public func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try auth.signOut()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
        
    }
    
    public func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        DatabaseManager.shared.findUserWithEmail(with: email) {
            [weak self] user in
            guard let user = user else {
                completion(.failure(AuthError.signInFailed))
                return
            }
            
            self?.auth.signIn(withEmail: email, password: password) {
                result, error in
                guard result != nil, error == nil else {
                    completion(.failure(AuthError.signInFailed))
                    return
                }
                UserDefaults.standard.setValue(user.username, forKey: "username")
                UserDefaults.standard.setValue(user.email, forKey: "email")
                UserDefaults.standard.setValue(user.userId, forKey: "userId")
                if user.isAnArtistAccount {
                    UserDefaults.standard.setValue("true", forKey: "isAnArtist")
                } else {
                    UserDefaults.standard.setValue("false", forKey: "isAnArtist")
                }
                completion(.success(user))
            }
        }
    }
    
    
    
    public func signUp(email: String, userName: String, password: String, profilePicture: Data?, firstName: String, lastName: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        let dateJoined = NSDate().timeIntervalSince1970
        let uniqueUserId = UUID().uuidString
        
        let newUser = User(isAnArtistAccount: false, email: email, username: userName.lowercased(), firstName: firstName.lowercased(), lastName: lastName.lowercased(), artistName: nil, dateJoined: dateJoined, userId: uniqueUserId, profileUrl: nil)
        
        auth.createUser(withEmail: email, password: password) {
            result, error in
            guard result != nil, error == nil else {
                completion(.failure(AuthError.newUserCreation))
                return
            }
            
            DatabaseManager.shared.createUser(newuser: newUser) {
                success in
                
                UserDefaults.standard.set(uniqueUserId, forKey: "userId")
                
                if success {
                    completion(.success(newUser))
                    
                    StorageManager.shared.uploadProfilePicture(userId: uniqueUserId, data: profilePicture) {
                        uploadSuccess in
                        if uploadSuccess {
                            print("success")
                        }
                    }
                    
                    DatabaseManager.shared.createLikedPlaylistForUser(userId: uniqueUserId, email: newUser.email, completion: {
                        success in
                        if success {
                            print("success")
                        }
                    })
                    
                } else {
                    completion(.failure(AuthError.newUserCreation))
                }
            }
            
        }
    }
    
    public func changeUsername(userId: String, newUsername: String, email: String, password: String, completion: @escaping(Bool, ChangeUsernameError) -> Void) {
        let user = Auth.auth().currentUser
        let credential: AuthCredential = FirebaseAuth.EmailAuthProvider.credential(withEmail: email, password: password)
        user?.reauthenticate(with: credential) { result, error in
          if error != nil {
              completion(false, .wrongPassword)
              return
          } else {
              DatabaseManager.shared.changeUsername(newUsername: newUsername, userId: userId, completion: {
                  success in
                  completion(success, .databaseIssue)
              })
          }
        }
    }
    
    let controller = MPMediaPickerController(mediaTypes: .anyAudio)
    
}
