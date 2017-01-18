//
//  PlayerTableViewCell.swift
//  ProjectInBetWin
//
//  Created by Arvin San Miguel on 1/5/17.
//  Copyright © 2017 Appr1sing Studios. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    var playerNameLabel: UILabel!
    var playerImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        
        self.backgroundColor = UIColor.clear
        
        playerImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 55, height: 55))
        playerImageView.clipsToBounds = true
        playerImageView.layer.borderColor = UIColor.black.cgColor
        playerImageView.layer.borderWidth = 1.5
        playerImageView.layer.cornerRadius = playerImageView.frame.height/2
        contentView.addSubview(playerImageView)
        
        playerNameLabel = UILabel(frame: CGRect(x: 5, y: contentView.frame.height, width: 55, height: 55))
        playerNameLabel.textAlignment = .center
        playerNameLabel.numberOfLines = 0
        playerNameLabel.font = UIFont(name: "GillSans-Light", size: 12)
        contentView.addSubview(playerNameLabel)
        
        
        
    }
    
    
}
