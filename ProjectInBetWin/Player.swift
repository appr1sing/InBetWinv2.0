//
//  Player.swift
//  ProjectInBetWin
//
//  Created by Arvin San Miguel on 1/5/17.
//  Copyright © 2017 Appr1sing Studios. All rights reserved.
//

import Foundation


struct Player {
    
    var uid: String
    var firstName: String
    var photoURL: String
    
    init(dictionary: firebaseJSON) {
        let uid = dictionary["uid"] as? String ?? ""
        let firstName = dictionary["first_name"] as? String ?? ""
        let photoURL = dictionary["photoURL"] as? String ?? ""
        
        self.uid = uid
        self.firstName = firstName
        self.photoURL = photoURL
        
    }
    
    init() {
        self.uid = ""
        self.firstName = ""
        self.photoURL = ""
    }
    
    // MARK: - create a dictionary
    func toAnyObject() -> firebaseJSON {
        
        return [ uid : [ "firstName": firstName, "photoURL": photoURL] ]
    }
    
}
