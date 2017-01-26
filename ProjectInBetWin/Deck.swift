//
//  Deck.swift
//  InBetWin
//
//  Created by Arvin San Miguel on 11/19/16.
//  Copyright © 2016 com.AppRising.JAMM. All rights reserved.
//

import Foundation

class Deck {
    
    let apiClient = CardAPIClient.shared
    var cards: [Card] = []
    var success = false
    var deckID: String!
    var remaining: Int!
    
    func newDeck(_ completion: @escaping (String) -> Void) {
        
        apiClient.newDeckShuffled({ _ , json in
            
            guard let remainingCard = json["remaining"] as? Int else { return }
            guard let success = json["success"] as? Bool else { return }
            guard let deckID = json["deck_id"] as? String else { return }
            
            OperationQueue.main.addOperation {
                
                self.success = success
                self.deckID = deckID
                self.remaining = remainingCard
                completion(deckID)
            }
            
        })
        
    }
    
    
    
    
    func drawCards(_ deckID: String, numberOfCards count: Int, handler completion: @escaping (Bool,[Card]?) -> Void) {
        
        apiClient.drawCardForPlayers(deckID, numberOfCards: count, completion: { json in
            
            guard let cardJSON = json["cards"] as? [[String:Any]] else { return }
            for card in cardJSON {
                OperationQueue.main.addOperation {
                    self.cards.append(Card(dictionary: card))
                    self.remaining = json["remaining"] as! Int
                    completion(true, self.cards)
                }
            }
            
        })
        
        
    }
    
    func retrieveDeck(_ deckID: String, with completion: @escaping (Bool) -> Void) {
        
        apiClient.drawCardForPlayers(deckID, numberOfCards: 0, completion: { json in
            
            guard let remainingCard = json["remaining"] as? Int else { return }
            guard let success = json["success"] as? Bool else { return }
            
            OperationQueue.main.addOperation {
                
                self.success = success
                self.deckID = deckID
                self.remaining = remainingCard
                completion(true)
                
            }
            
        })
        
        
    }
    
}
