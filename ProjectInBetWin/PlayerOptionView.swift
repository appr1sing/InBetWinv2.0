//
//  PlayerOption.swift
//  ProjectInBetWin
//
//  Created by Arvin San Miguel on 12/27/16.
//  Copyright © 2016 Appr1sing Studios. All rights reserved.
//

import UIKit

class PlayerOptionView: UIView {

    let hostButton = UIButton()
    let joinButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.black.cgColor
        self.isUserInteractionEnabled = true
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        addSubview(hostButton)
        hostButton.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height/2)
        hostButton.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        hostButton.layer.borderWidth = 0.5
        hostButton.setTitle("HOST GAME", for: .normal)
        hostButton.setTitleColor(UIColor.black, for: .normal)
        
        addSubview(joinButton)
        joinButton.frame = CGRect(x: 0.0, y: hostButton.frame.height, width: bounds.width, height: bounds.height/2)
        joinButton.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        joinButton.layer.borderWidth = 0.5
        joinButton.setTitle("JOIN GAME", for: .normal)
        joinButton.setTitleColor(UIColor.black, for: .normal)
        
    }
        
}
