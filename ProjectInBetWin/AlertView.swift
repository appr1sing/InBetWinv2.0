//
//  AlertView.swift
//  ProjectInBetWin
//
//  Created by Arvin San Miguel on 1/10/17.
//  Copyright © 2017 Appr1sing Studios. All rights reserved.
//

import UIKit

protocol AlertViewDelegate: class {
    func readyButtonTapped(with sender: AlertView)
}


class AlertView: UIView {
    
    weak var delegate: AlertViewDelegate?
    var notificationLabel : UILabel!
    let readyButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func commonInit() {
        
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        notificationLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width * 0.7, height: self.frame.width * 0.2))
        notificationLabel.numberOfLines = 0
        notificationLabel.text = "WAITING FOR OTHER PLAYERS..."
        notificationLabel.textColor = UIColor.white
        notificationLabel.font = UIFont(name: "AvenirNext-UltraLight", size: 25)
        notificationLabel.textAlignment = .center
        notificationLabel.center.y = frame.midY * 0.8
        notificationLabel.center.x = center.x
        addSubview(notificationLabel)
        
    }
    
    
    
    func hide() {
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseInOut, animations: {
            
            self.notificationLabel.alpha = 0.0
            
        }, completion: { _ in self.addReadyButton() })
        
    }
    
    func unHide() {
        
        readyButton.removeFromSuperview()
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseInOut, animations: {
            
            self.notificationLabel.alpha = 1.0
            
            
        }, completion: nil)
    
    }
    
    func addReadyButton() {
        
        readyButton.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width * 0.7, height: self.frame.width * 0.2)
        readyButton.setTitle("READY?", for: .normal)
        readyButton.titleLabel?.textColor = UIColor.white
        readyButton.titleLabel?.font = UIFont(name: "AvenirNext-UltraLight", size: 20)
        readyButton.layer.cornerRadius = 20.0
        readyButton.layer.borderWidth = 3.0
        readyButton.layer.borderColor = UIColor.white.cgColor
        readyButton.titleLabel?.textAlignment = .center
        readyButton.center.y = frame.midY * 0.8
        readyButton.center.x = center.x
        readyButton.addTarget(self, action: #selector(self.readyButtonTapped), for: .touchUpInside)
        readyButton.layoutSubviews()
        addSubview(readyButton)
        
    }
    
    func readyButtonTapped() {
        delegate?.readyButtonTapped(with: self)
    }
    
    func hideReadyButton() {
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseInOut, animations: {
            
            self.alpha = 0.0
            
        }, completion: nil)
        
    }
    
    
    
    
}
