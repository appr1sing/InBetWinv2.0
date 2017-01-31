//
//  JoinGameViewController.swift
//  ProjectInBetWin
//
//  Created by Arvin San Miguel on 12/28/16.
//  Copyright © 2016 Appr1sing Studios. All rights reserved.
//

import UIKit
import Firebase

class JoinGameViewController: UIViewController {
    
    let firebaseModel = FirebaseModel()
    var joinTableView : UITableView!
    var games = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupFireBase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //retrieveGamesFromFirebase()
        //self.joinTableView.reloadData()
    }
    
    private func setupViews() {
        setupTableView()
        setupNavBarItems()
    }
    
    private func setupFireBase() {
        //retrieveGamesFromFirebase()
        NotifyFirebase()
    }
    
    func NotifyFirebase() {
        
        firebaseModel.rootRef.child("current_games").observe(.childAdded, with: { snapshot in
            
            guard let game = snapshot.key as? String else { return }
            self.games.append(game)
            if let index = self.games.index(of: game) {
                self.joinTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                self.joinTableView.reloadData()
            }
            
        })
        
        firebaseModel.rootRef.child("current_games").observe(.childRemoved, with: { snapshot in
            
            guard let game = snapshot.key as? String else { return }
            if let index = self.games.index(of: game) {
                self.games.remove(at: index)
                self.joinTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                self.joinTableView.reloadData()
            }
            
        })
    }
    
    func retrieveGamesFromFirebase() {
        
        firebaseModel.retrieveHostedGames { (games) in
            self.games = games
            self.joinTableView.reloadData()
        }
    }
    
}

extension JoinGameViewController : UITableViewDataSource, UITableViewDelegate {
    
    func setupTableView() {
        
        //Setup TableView
        
        joinTableView = UITableView(frame: view.frame, style: .plain)
        joinTableView.delegate = self
        joinTableView.dataSource = self
        joinTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(joinTableView)
    }
    
    func setupNavBarItems() {
    
        //Setup NavBar Button
        let backButton = UIBarButtonItem()
        let backButtonView = BackButtonView(frame: CGRect(x: 0.0, y: 0.0, width: 50, height: 50))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissVC))
        tap.numberOfTapsRequired = 1
        backButtonView.addGestureRecognizer(tap)
        backButtonView.backgroundColor = UIColor.clear
        
        backButton.customView = backButtonView
        navigationItem.leftBarButtonItem = backButton
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = games[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "hostVC") as! HostGameViewController
        vc.host = games[indexPath.row]
        firebaseModel.addPlayerToGame(hostedBy: games[indexPath.row])
        let navigationVC = UINavigationController(rootViewController: vc)
        present(navigationVC, animated: true, completion: nil)
        
    }
    
    func dismissVC() {
            dismiss(animated: true, completion: nil)
    }
    
}
