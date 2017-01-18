//
//  Card.swift
//  InBetWin
//
//  Created by Arvin San Miguel on 11/19/16.
//  Copyright © 2016 com.AppRising.JAMM. All rights reserved.
//

import Foundation
import UIKit

class Card {
    
    let imageURLString: String
    let url: URL?
    let code: String
    var image: UIImage?
    let value: String
    let suit: String
    let apiClient = CardAPIClient.shared
    var isDownloading = false
    
    init(dictionary values: firebaseJSON) {
        
        guard let imageURL = values["image"] as? String else { fatalError() }
        guard let value = values["value"] as? String else { fatalError() }
        guard let suit = values["suit"] as? String else { fatalError() }
        guard let code = values["code"] as? String else { fatalError() }
        
        self.imageURLString = imageURL
        self.value = value
        self.suit = suit
        self.code = code
        self.url = URL(string: imageURL)
        
    }
    
    func downloadImage(_ handler: @escaping (Bool) -> Void) {
        
        if let url = url {
           apiClient.downloadImage(at: url, handler: { success, image in
                guard let image = image else { return }
                OperationQueue.main.addOperation {
                    self.image = image
                    handler(true)
                }
            })
        }
    }
    
}
