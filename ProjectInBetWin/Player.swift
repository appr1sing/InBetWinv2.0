//
//  Player.swift
//  ProjectInBetWin
//
//  Created by Arvin San Miguel on 1/5/17.
//  Copyright © 2017 Appr1sing Studios. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Player {
    
    var uid: String
    var firstName: String
    var photoURL: String
    var tokens : Int
    var time : Any
    
    init(dictionary: firebaseJSON) {
        let uid = dictionary["uid"] as? String ?? ""
        let firstName = dictionary["first_name"] as? String ?? ""
        let photoURL = dictionary["photoURL"] as? String ?? ""
        let tokens = dictionary["tokens"] as? Int ?? 0
        
        self.uid = uid
        self.firstName = firstName
        self.photoURL = photoURL
        self.time = FIRServerValue.timestamp()
        self.tokens = tokens
        
    }
    
    init() {
        self.uid = ""
        self.firstName = ""
        self.photoURL = ""
        self.time = ""
        self.tokens = 0
        
    }
    
    // MARK: - create a dictionary
    func toAnyObject() -> firebaseJSON {
        
        return [ uid : [ "firstName": firstName, "photoURL": photoURL, "timeStamp" : time ] ]
    
    }
    
}
