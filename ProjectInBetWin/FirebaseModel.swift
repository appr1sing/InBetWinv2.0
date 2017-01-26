//
//  FirebaseModel.swift
//  ProjectInBetWin
//
//  Created by Arvin San Miguel on 12/24/16.
//  Copyright © 2016 Appr1sing Studios. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FirebaseModel {
    
    let rootRef = FIRDatabase.database().reference().child("game")
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    public func registerPlayer(_ uid: String, email: String, firstName: String, lastName: String, status: Bool, photoURL: String) {
        
        let playerRef = rootRef.child("players/\(uid)")
        playerRef.child("uid").setValue(uid)
        playerRef.child("email").setValue(email)
        playerRef.child("first_name").setValue(firstName)
        playerRef.child("last_name").setValue(lastName)
        playerRef.child("inGame").setValue(status)
        playerRef.child("photoURL").setValue(photoURL)
        
    }
    
    public func hostedGame(with hostName: String) {
        
        let playerRef = rootRef.child("players/\(uid!)")
        playerRef.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let result = snapshot.value as? firebaseJSON else { return }
            let hostUser = Player(dictionary: result)
            self.rootRef.child("current_games/\(hostName)/players").setValue(hostUser.toAnyObject())
            
        })
        
    }
    
    public func addPlayerToGame(hostedBy player: String) {
        
        let playerRef = self.rootRef.child("players/\(self.uid!)")
        let gameRef = self.rootRef.child("current_games/\(player)/players")
        
        playerRef.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let result = snapshot.value as? firebaseJSON else { return }
            let hostUser = Player(dictionary: result)
            gameRef.updateChildValues(hostUser.toAnyObject())
            
        })
        
    }

    public func leaveGame(hostedBy player: String) {
        
        let playerRef = rootRef.child("current_games/\(player)/players")
        if let uid = uid {
            playerRef.child("\(uid)").removeValue()
        }
        
    }
    
    public func checkIfThereIsPlayersInGame(with roomName: String) {
        let gameRef = rootRef.child("current_games/\(roomName)")
        gameRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let game = snapshot.value as? firebaseJSON else { return }
            guard let checkPlayers = game["players"] as? firebaseJSON else { gameRef.removeValue(); return }
        })
        
    }
    
    public func retrieveHostedGames(with completion: @escaping ([String]) -> ()) {
        
        let playerRef = self.rootRef.child("current_games")
        
        playerRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var hostedGames = [String]()
            guard let results = snapshot.value as? [String: AnyObject] else { return }
            
            for (key,_) in results {
                hostedGames.append(key)
            }
            
            completion(hostedGames)
            
        })
        
    }
    
    public func addTokenToUser() {
        
        let playerRef = self.rootRef.child("players/\(uid!)/tokens")
        playerRef.setValue(100)
        
    }
    
    public func addHostToCurrentGame(with deckID: String, hostName: String) {
        
        let gameRef = self.rootRef.child("current_games/\(hostName)/deckID")
        gameRef.setValue(deckID)
        
    }
    
    public func addPlayerStatusToGame(hostedBy roomName: String) {
        
        let playerRef = self.rootRef.child("current_games/\(roomName)/players/\(uid!)")
        playerRef.child("isTurnToBet").setValue(false)
        
    }
    
    public func selectRandomPlayer(hostedBy roomName: String, with completion: @escaping (String) -> ()) {
        let playerRef = self.rootRef.child("current_games/\(roomName)/players")
        
        playerRef.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let results = snapshot.value as? firebaseJSON else { return }
            var players = [String]()
            for (key, _) in results {
                players.append(key)
            }
            let index = Int(arc4random_uniform(UInt32(players.count)))
            let randomPlayer = players[index]
            self.rootRef.child("current_games/\(roomName)/playerTurnToBet").setValue(randomPlayer)
            
            completion(randomPlayer)
        
        })
        
    }
    
    public func getRandomPlayer(hostedBy roomName: String, with completion: @escaping (String) -> ()) {
        
        let playerRef = self.rootRef.child("current_games/\(roomName)/playerTurnToBet")
        
        playerRef.observeSingleEvent(of: .value, with: { snapshot in
        
            guard let result = snapshot.value as? String else { return }
            completion(result)
            
        })
        
    }
 
    public func getDeckID(hostedBy roomName: String, with completion: @escaping (String) -> ()) {
        
        let playerRef = self.rootRef.child("current_games/\(roomName)/deckID")
        playerRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let result = snapshot.value as? String else { return }
            completion(result)
        })
        
    }
    
    public func nextPlayerToBet(hostedBy roomName: String, uid: String) {
        
        let playerRef = self.rootRef.child("current_games/\(roomName)/playerTurnToBet")
        playerRef.setValue(uid)
    }
    
}


