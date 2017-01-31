//
//  PlayersTableView.swift
//  ProjectInBetWin
//
//  Created by Arvin San Miguel on 1/9/17.
//  Copyright © 2017 Appr1sing Studios. All rights reserved.
//

import UIKit

protocol PlayerOptionButtonsDelegate : class {
    func betButtonTapped(with sender: PlayersTableView)
    func foldButtonTapped(with sender: PlayersTableView)
    func amountLabelTapped(with sender: PlayersTableView)
    
}


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
    var potLabel : UILabel!
    var moneyLabel : UILabel!
 
    weak var delegate : PlayerOptionButtonsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
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
        
        potLabel = UILabel()
        addSubview(potLabel)
        potLabel.translatesAutoresizingMaskIntoConstraints = false
        potLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        potLabel.bottomAnchor.constraint(equalTo: minusButton.topAnchor).isActive = true
        potLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        potLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        moneyLabel = UILabel()
        addSubview(moneyLabel)
        moneyLabel.translatesAutoresizingMaskIntoConstraints = false
        moneyLabel.leftAnchor.constraint(equalTo: potLabel.rightAnchor).isActive = true
        moneyLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        moneyLabel.bottomAnchor.constraint(equalTo: minusButton.topAnchor).isActive = true
        moneyLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
    private func setupAttributes() {
        
        foldButton.setTitle("FOLD", for: .normal)
        foldButton.setTitleColor(UIColor.white, for: .normal)
        foldButton.titleLabel?.textAlignment = .center
        foldButton.titleLabel?.font = UIFont(name: "AvenirNext-UltraLight", size: 20)
        foldButton.addTarget(self, action: #selector(self.foldButtonTapped), for: .touchUpInside)
        
        betButton.setTitle("BET", for: .normal)
        betButton.setTitleColor(UIColor.white, for: .normal)
        betButton.titleLabel?.textAlignment = .center
        betButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        betButton.addTarget(self, action: #selector(self.betButtonTapped), for: .touchUpInside)
        
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
        amountLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)
        amountLabel.text = "10"
        amountLabel.textAlignment = .center
        amountLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.amountLabelTapped(_:)))
        tap.numberOfTapsRequired = 1
        amountLabel.addGestureRecognizer(tap)
        
    
        potLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        potLabel.textColor = UIColor.white
        potLabel.numberOfLines = 0
        potLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)
        potLabel.text = "POT MONEY"
        potLabel.textAlignment = .center
        
        moneyLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        moneyLabel.textColor = UIColor.white
        moneyLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)
        moneyLabel.text = "$ 10000"
        moneyLabel.textAlignment = .center
        
    }
    
    func amountLabelTapped(_ sender: UITapGestureRecognizer) {
        delegate?.amountLabelTapped(with: self)
    }
    
    func foldButtonTapped() {
        delegate?.foldButtonTapped(with: self)
        
    }
    
    func betButtonTapped() {
        delegate?.betButtonTapped(with: self)
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
    
    
    public func animate(with imageData1: String, imageData2: String) {
        
        // create a 'tuple' (a pair or more of objects assigned to a single variable)
        frontViewFirstCard.frame = backViewFirstCard.frame
        
        let imgUrl1 = URL(string: imageData1)
        let dataImg1 = try! Data(contentsOf: imgUrl1!)
        frontViewFirstCard.image = UIImage(data: dataImg1)
        
        let imgUrl2 = URL(string: imageData2)
        let dataImg2 = try! Data(contentsOf: imgUrl2!)
        frontViewSecondCard.image = UIImage(data: dataImg2)
        frontViewSecondCard.frame = backViewSecondCard.frame
        
        addSubview(frontViewFirstCard)
        addSubview(frontViewSecondCard)
        
        let view1 = (frontView: frontViewFirstCard, backView: backViewFirstCard)
        let view2 = (frontView: frontViewSecondCard, backView: backViewSecondCard)
        
        
        // set a transition style
        let transitionOptions1 = UIViewAnimationOptions.transitionFlipFromRight
        let transitionOptions2 = UIViewAnimationOptions.transitionFlipFromLeft
        
        UIView.transition(with: self.firstContainerView, duration: 1.0, options: transitionOptions1, animations: {
            // remove the front object...
            view1.frontView.removeFromSuperview()
            
            // ... and add the other object
            self.firstContainerView.addSubview(view1.frontView)
            
            
        }, completion: { finished in
            // any code entered here will be applied
            // .once the animation has completed
        })
        
        
        UIView.transition(with: self.secondContainerView, duration: 1.0, options: transitionOptions2, animations: {
            // remove the front object...
            view2.frontView.removeFromSuperview()
            
            // ... and add the other object
            self.secondContainerView.addSubview(view2.frontView)
            
            
        }, completion: { finished in
            // any code entered here will be applied
            // .once the animation has completed
        })
        
        
        
    }
    
    func removeCurrentImages() {
        
        frontViewFirstCard.image = nil
        frontViewSecondCard.image = nil
        
        
    }
    
    
    
}
