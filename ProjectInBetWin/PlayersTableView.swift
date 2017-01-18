//
//  PlayersTableView.swift
//  ProjectInBetWin
//
//  Created by Arvin San Miguel on 1/9/17.
//  Copyright © 2017 Appr1sing Studios. All rights reserved.
//

import UIKit

class PlayersTableView: UIView {

    let firstContainerView = UIView()
    let backViewFirstCard = UIImageView()
    let frontViewFirstCard = UIImageView()
    
    let secondContainerView = UIView()
    let backViewSecondCard = UIImageView()
    let frontViewSecondCard = UIImageView()
    
    let thirdContainerView = UIView()
    let backViewDealerCard = UIImageView()
    let frontViewDealerCard = UIImageView()
    
    var betButton : UIButton!
    var foldButton : UIButton!
    var minusButton : UIButton!
    var addButton : UIButton!
    var amountLabel : UILabel!
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func commonInit() {
        addSubviews()
        layoutCardViews()
        layoutButtons()
        setupAttributes()
    }
    
    private func addSubviews() {
        
        addSubview(firstContainerView)
        addSubview(secondContainerView)
        addSubview(thirdContainerView)
        
        addSubview(frontViewFirstCard)
        addSubview(frontViewSecondCard)
        addSubview(frontViewDealerCard)
        
        firstContainerView.addSubview(backViewFirstCard)
        secondContainerView.addSubview(backViewSecondCard)
        thirdContainerView.addSubview(backViewDealerCard)

    }
    
    private func layoutCardViews() {
        
        let cardWidth : CGFloat = frame.width * 0.33
        let cardHeight : CGFloat = frame.width * 0.50
        
        firstContainerView.frame = CGRect(x: frame.width * 0.125, y: frame.width * 0.75, width: cardWidth, height: cardHeight)
        backViewFirstCard.frame = CGRect(x: 0.0, y: 0.0, width: firstContainerView.frame.width, height: firstContainerView.frame.height)
        backViewFirstCard.clipsToBounds = true
        backViewFirstCard.layer.cornerRadius = 6.0
        backViewFirstCard.image = #imageLiteral(resourceName: "cardDeck")
        backViewFirstCard.backgroundColor = UIColor.clear
        
        secondContainerView.frame = CGRect(x: frame.width * 0.56, y: frame.width * 0.75, width: cardWidth, height: cardHeight)
        backViewSecondCard.frame = CGRect(x: 0.0, y: 0.0, width: secondContainerView.frame.width, height: secondContainerView.frame.height)
        backViewSecondCard.clipsToBounds = true
        backViewSecondCard.layer.cornerRadius = 6.0
        backViewSecondCard.image = #imageLiteral(resourceName: "cardDeck")
        backViewSecondCard.backgroundColor = UIColor.clear
        
        thirdContainerView.frame = CGRect(x: 0, y: center.y * 0.10, width: cardWidth, height: cardHeight)
        thirdContainerView.center.x = frame.width * 0.5
        backViewDealerCard.frame = CGRect(x: 0.0, y: 0.0, width: thirdContainerView.frame.width, height: thirdContainerView.frame.height)
        backViewDealerCard.layer.cornerRadius = 6.0
        backViewDealerCard.clipsToBounds = true
        backViewDealerCard.image = #imageLiteral(resourceName: "cardDeck")
        backViewDealerCard.backgroundColor = UIColor.clear
        
    }
    
    private func layoutButtons() {
        
        // Setup Constraints
        foldButton = UIButton(type: .system)
        addSubview(foldButton)
        foldButton.translatesAutoresizingMaskIntoConstraints = false
        foldButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        foldButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        foldButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        foldButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        foldButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        betButton = UIButton(type: .system)
        addSubview(betButton)
        betButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        betButton.translatesAutoresizingMaskIntoConstraints = false
        betButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        betButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        betButton.leftAnchor.constraint(equalTo: foldButton.rightAnchor).isActive = true
        betButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        minusButton = UIButton(type: .system)
        addSubview(minusButton)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        minusButton.bottomAnchor.constraint(equalTo: foldButton.topAnchor).isActive = true
        minusButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        minusButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        minusButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        
        addButton = UIButton(type: .system)
        addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        addButton.bottomAnchor.constraint(equalTo: betButton.topAnchor).isActive = true
        addButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        addButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        amountLabel = UILabel()
        addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.leftAnchor.constraint(equalTo: minusButton.rightAnchor).isActive = true
        amountLabel.rightAnchor.constraint(equalTo: addButton.leftAnchor).isActive = true
        amountLabel.bottomAnchor.constraint(equalTo: foldButton.topAnchor).isActive = true
        amountLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
    }
    
    private func setupAttributes() {
        
        foldButton.setTitle("FOLD", for: .normal)
        foldButton.setTitleColor(UIColor.white, for: .normal)
        foldButton.titleLabel?.textAlignment = .center
        foldButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        foldButton.addTarget(self, action: #selector(self.testFoldButton(sender:)), for: .touchUpInside)
        
        betButton.setTitle("BET", for: .normal)
        betButton.setTitleColor(UIColor.white, for: .normal)
        betButton.titleLabel?.textAlignment = .center
        betButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        betButton.addTarget(self, action: #selector(self.testFoldButton(sender:)), for: .touchUpInside)
        
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.titleLabel?.textAlignment = .center
        addButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 40)
        addButton.addTarget(self, action: #selector(self.addBet(sender:)), for: .touchUpInside)
        
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(UIColor.white, for: .normal)
        minusButton.titleLabel?.textAlignment = .center
        minusButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 40)
        minusButton.addTarget(self, action: #selector(self.subtractBet(sender:)), for: .touchUpInside)
        
        amountLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        amountLabel.textColor = UIColor.white
        amountLabel.font = UIFont(name: "AvenirNext-Regular", size: 30)
        amountLabel.text = "10"
        amountLabel.textAlignment = .center
    
    }
    
    func testFoldButton(sender: UIButton) {
        
    }
    
    func addBet(sender: UIButton) {
        let value : Int = Int(amountLabel.text!)!
        amountLabel.text = String(value + 5)
    }
    
    func subtractBet(sender: UIButton) {
        let value : Int = Int(amountLabel.text!)!
        if value <= 0 { return }
        amountLabel.text = String(value - 5)
    }
    
    
    
}
