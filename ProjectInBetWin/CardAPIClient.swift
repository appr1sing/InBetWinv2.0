//
//  CardAPIClient.swift
//  ProjectInBetWin
//
//  Created by Arvin San Miguel on 1/7/17.
//  Copyright © 2017 Appr1sing Studios. All rights reserved.
//

import Foundation
import UIKit

struct CardAPIClient {
    
    static let shared = CardAPIClient()
    
    private init() {}
    
    func newDeckShuffled(_ completion: @escaping (String, firebaseJSON) -> ()) {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let url = URL(string: "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=2")
        let task = session.dataTask(with: url!) { data, error , response in
            
            guard let data = data else { fatalError() }
            guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as! firebaseJSON else { return }
            guard let deckID = responseJSON["deck_id"] as? String else { return }
            
            OperationQueue.main.addOperation {
                completion(deckID, responseJSON)
            }
            
        }
        task.resume()
    }
    
    func drawCardForPlayers(_ deckID: String, numberOfCards count: Int, completion: @escaping (firebaseJSON) -> ()) {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let url = URL(string: "https://deckofcardsapi.com/api/deck/\(deckID)/draw/?count=\(count)")
        let task = session.dataTask(with: url!) { data, error, response in
            
            guard let data = data else { return }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as! firebaseJSON
            if let json = responseJSON {
                OperationQueue.main.addOperation {
                    print(json)
                    completion(json)
                }
            }
        }
        task.resume()
    }
    
    func downloadImage(at url: URL, handler completion: @escaping (Bool, UIImage?) -> Void) {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url) { data, error, response in
            
            guard let imageData = try? Data(contentsOf: url) else { fatalError() }
            OperationQueue.main.addOperation {
                let image = UIImage(data: imageData)
                completion(true, image)
            }
            
        }
        task.resume()
        
    }
}
