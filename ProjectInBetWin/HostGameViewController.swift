//
//  HostGameViewController.swift
//  ProjectInBetWin
//
//  Created by Arvin San Miguel on 1/3/17.
//  Copyright © 2017 Appr1sing Studios. All rights reserved.
//

import UIKit
import Firebase

typealias firebaseJSON = [String: Any]

class HostGameViewController: UIViewController {
    
    let firebase = FirebaseModel()
    let deck = Deck()
    let apiClient = CardAPIClient.shared
    
    var playerTableView : PlayersTableView!
    var deckID : String?
    var hostTableView : UITableView!
    var newPlayers = [Player]()
    var hostPlayer = false
    var host : String?
    var alertView: AlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupMechanics()
        setupDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hostTableView.reloadData()
    }
    
    func setupViews() {
        setupTableView()
        setupNavBarItems()
    }
    
    func setupMechanics() {
        verifyHostStatus()
        notifyFirebase()
        notifyPlayersTurn()
    }
    
    func setupDelegates() {
        alertView.delegate = self
        playerTableView.delegate = self
    }
    
    func verifyHostStatus() {
        
        if hostPlayer {
            
            addHost()
            
        } else {
            
            firebase.getDeckID(hostedBy: host!, with: { deckID in
                print("\nDECK ID FROM FIREBASE \(deckID)\n")
                self.deckID = deckID
                self.deck.retrieveDeck(deckID, with: { success in
                    
                    print("\n REMAINING CARDS : \(self.deck.remaining)")
                    
                })
                
            })
        }
        
    }
    
    func addHost() {
        
        deck.newDeck({ deckID in
            
            self.deckID = deckID
            self.firebase.addHostToCurrentGame(with: deckID, hostName: self.host!)
            
        })
        
    }
    
    func notifyFirebase() {
        
        let playerRef = firebase.rootRef.child("current_games").child("\(host!)/players")
        
        playerRef.observe(.childAdded, with: { snapshot in
            
            guard let results = snapshot.key as? String else { return }
            self.firebase.rootRef.child("players/\(results)").observeSingleEvent(of: .value, with: { snapshot in
                
                guard let result = snapshot.value as? firebaseJSON else { return }
                let user = Player(dictionary: result)
                self.newPlayers.append(user)
                self.hostTableView.insertRows(at: [IndexPath(row: self.newPlayers.count - 1, section: 0)], with: .fade)
                
                
                
                if self.newPlayers.count == 1 && self.hostPlayer {
                    self.alertView.notifyToWaitForOtherPlayers()
                } else if self.newPlayers.count > 1 && self.hostPlayer {
                    self.alertView.hideNotificationLabel()
                    self.alertView.addReadyButton()
                } else if self.newPlayers.count > 1 && !self.hostPlayer {
                    self.alertView.notifyPlayerJoined(user.firstName)
                }
                
                
                
            })
            
        })
        
        playerRef.observe(.childRemoved, with: { snapshot in
            
            guard let player = snapshot.key as? String else { return }
            
            if let index = self.newPlayers.index(where: { $0.uid == player }) {
                
                self.newPlayers.remove(at: index)
                self.hostTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                
                if self.newPlayers.count == 1 {
                    self.hostPlayer = true
                    self.alertView.notifyToWaitForOtherPlayers()
                }
                
                if self.newPlayers.count > 1 && (self.hostPlayer || !self.hostPlayer) {
                    self.alertView.notifyPlayerLeft(self.newPlayers[index].firstName)
                }
                
            }
            
        })
        
       
    }
    
}

extension HostGameViewController : AlertViewDelegate {
    
    func readyButtonTapped(with sender: AlertView) {
        
        alertView.hideReadyButton()
        
        if let host = host {
            
            if hostPlayer {
                
                firebase.selectRandomPlayer(hostedBy: host, with: { randomPlayer in
                    
                    for player in self.newPlayers {
                        if player.uid == randomPlayer {
                            self.alertView.displayPlayerName(player.firstName)
                        }
                    }
                    
                })
                
                
            } 
        }
        
    }

    func notifyPlayersTurn() {
        
        let playerRef = firebase.rootRef.child("current_games").child("\(host!)")
        
        playerRef.observe(.value, with: { snapshot in
            
            guard let result = snapshot.value as? firebaseJSON else { return }
            guard let playerName = result["playerTurnToBet"] as? String else { return }
            
            if self.firebase.uid == playerName {
                
                self.alertView.displaySelfName()
                self.playerTableView.isUserInteractionEnabled = true
                if let deckID = self.deckID {
                    
                    self.deck.drawCards(deckID, numberOfCards: 3, handler: { success, cards in
                        
                        for card in cards! {
                            print("\(card.suit)  \(card.value)")
                        }
                        
                    })
                    
                }
                
            } else { 
                
                for player in self.newPlayers {
                    
                    if player.uid == playerName {
                        self.alertView.displayPlayerName(player.firstName)
                    }
                }
                
                self.playerTableView.isUserInteractionEnabled = false
                
            }
            
        })
    }
    
}

extension HostGameViewController : PlayerOptionButtonsDelegate {
    
    func betButtonTapped(with sender: PlayersTableView) {
        print("BET")
        
        firebase.getRandomPlayer(hostedBy: host!, with: { currentPlayer in
            
            for (index,player) in self.newPlayers.enumerated() {
                let next = index + 1
                if player.uid == currentPlayer && next != self.newPlayers.count {
                    self.firebase.nextPlayerToBet(hostedBy: self.host!, uid: self.newPlayers[next].uid)
                } else if player.uid == currentPlayer && next >= self.newPlayers.count {
                    self.firebase.nextPlayerToBet(hostedBy: self.host!, uid: self.newPlayers[0].uid)
                }
                
            }
            
        })
        
    }
    
    func foldButtonTapped(with sender: PlayersTableView) {
        print("FOLD")
        playerTableView.animate(with: deck.cards[0].imageURLString, imageData2: deck.cards[1].imageURLString)
    }
    
    
}


extension HostGameViewController : UITableViewDataSource, UITableViewDelegate {
    
    func setupTableView() {
        
        self.edgesForExtendedLayout = .bottom
        self.extendedLayoutIncludesOpaqueBars = true
        
        let frame = CGRect(x: 0.0, y: 0.0, width: 65, height: view.frame.height)
        hostTableView = UITableView(frame: frame, style: .plain)
        hostTableView.delegate = self
        hostTableView.dataSource = self
        hostTableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: "cell")
        hostTableView.separatorStyle = .none
        //hostTableView.backgroundColor = UIColor(red: 0, green: 156/255.0, blue: 59/255.0, alpha: 1.0)
        hostTableView.backgroundColor = UIColor.white
        view.addSubview(hostTableView)
        
        let app = UIApplication.shared
        let height = app.statusBarFrame.size.height
        let navbarHeight = navigationController!.navigationBar.frame.height
        let frame2 = CGRect(x: hostTableView.frame.maxX, y: 0, width: (view.frame.width - hostTableView.frame.maxX), height: view.frame.height -  navbarHeight - height)
        playerTableView = PlayersTableView(frame: frame2)
        view.addSubview(playerTableView)
        playerTableView.backgroundColor = UIColor(red: 0, green: 156/255.0, blue: 59/255.0, alpha: 1.0)
        
        alertView = AlertView(frame: view.frame)
        view.addSubview(alertView)
        
        
    }
    
    func setupNavBarItems() {
        
        let backButton = UIBarButtonItem()
        let backButtonView = BackButtonView(frame: CGRect(x: 0.0, y: 0.0, width: 50, height: 50))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissVC))
        tap.numberOfTapsRequired = 1
        backButtonView.addGestureRecognizer(tap)
        backButtonView.backgroundColor = UIColor.clear
        
        backButton.customView = backButtonView
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = host
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlayerTableViewCell
        cell.playerNameLabel.text = newPlayers[indexPath.row].firstName
        cell.playerImageView.image = UIImage(data: try! Data(contentsOf: URL(string: newPlayers[indexPath.row].photoURL)!))
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {  print("\n from DIDSELECT : \(newPlayers) ") }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func dismissVC() {
        if let host = host {
            hostPlayer = false
            firebase.leaveGame(hostedBy: host)
            firebase.checkIfThereIsPlayersInGame(with: host)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
}
