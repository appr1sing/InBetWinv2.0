//
//  FacebookModel.swift
//  ProjectInBetWin
//
//  Created by Arvin San Miguel on 12/27/16.
//  Copyright © 2016 Appr1sing Studios. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Firebase

class FacebookModel {
    
    let firebase = FirebaseModel()
    
    public func getUserInfo() {
        
        let parameters = ["fields" :"email, first_name, last_name, picture.type(large)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            
            if error != nil { fatalError() }
            guard let result = result as? [String : AnyObject] else { fatalError() }
            guard let email = result["email"] as? String else { fatalError() }
            guard let firstName = result["first_name"] as? String else { fatalError() }
            guard let lastName = result["last_name"] as? String else { fatalError() }
            guard let picture = result["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String else { fatalError() }
            //guard let imageData = try? Data(contentsOf: URL(string: url as! String)!) else { fatalError() }
            
//            if let picture = result["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"]  {
//                guard let imageData = try? Data(contentsOf: URL(string: url as! String)!) else { fatalError() }
//            }
            
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if let error = error { print(error.localizedDescription) }
                if let uid = user?.uid {
                    self.firebase.registerPlayer(uid, email: email, firstName: firstName, lastName: lastName, status: true, photoURL: url)
                }
            }
        }
        
    }
    
    public func getUserPicture(with completion: @escaping (Data) -> Void) {
        
        let parameters = ["fields" :"email, first_name, last_name, picture.type(large)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            
            if error != nil { fatalError() }
            
            guard let result = result as? [String : AnyObject] else { fatalError() }
            if let picture = result["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"]  {
                guard let imageData = try? Data(contentsOf: URL(string: url as! String)!) else { fatalError() }
                completion(imageData)
            }
            
        }
    }
    
    
    
}
