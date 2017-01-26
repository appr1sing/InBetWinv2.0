//
//  ViewController.swift
//  ProjectInBetWin
//
//  Created by Arvin San Miguel on 12/28/16.
//  Copyright © 2016 Appr1sing Studios. All rights reserved.


import UIKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    let facebookModel = FacebookModel()
    let firebaseModel = FirebaseModel()
    let userDefaults = UserDefaults.standard
    
    let loginButton : FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email", "public_profile"]
        return button
    }()
    
    var playerOptionView : PlayerOptionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupViews()
        
    }
    
    private func setupViews() {
        
        setupLoginButton()
        setupPlayerOptionView()
        
    }
    
    private func setupLoginButton() {
        
        view.addSubview(loginButton)
        
        if FIRAuth.auth()?.currentUser != nil {

            loginButton.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width * 0.8, height: view.frame.height * 0.08)
            loginButton.center.x = view.center.x
            loginButton.center.y = view.center.y * 1.8
            
        } else {
            
            loginButton.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width * 0.8, height: view.frame.height * 0.08)
            loginButton.center = view.center
            
        }
        
        loginButton.delegate = self
        
    }
    
    private func setupPlayerOptionView() {
        
        let frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width * 0.8, height: view.frame.height * 0.16)
        playerOptionView = PlayerOptionView(frame: frame)
        playerOptionView.center = view.center
        playerOptionView.clipsToBounds = true
        playerOptionView.hostButton.addTarget(self, action: #selector(self.hostButtonTapped), for: .touchUpInside)
        playerOptionView.joinButton.addTarget(self, action: #selector(self.joinButtonTapped), for: .touchUpInside)
        playerOptionView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        if FIRAuth.auth()?.currentUser != nil {
            playerOptionView.alpha = 1.0
            playerOptionView.transform = CGAffineTransform.identity
        } else {
            playerOptionView.alpha = 0.0
        }
        view.addSubview(playerOptionView)
        
    }
    
    private func checkInProfile() {
        
        facebookModel.getUserInfo()
        animateButtonDownward()
        animatePlayerOptionView()
    
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil { fatalError("Error found while logging in...") }
        checkInProfile()
        
        print("SUCCESSFUL LOGIN . . .")
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            animateButtonUpward()
            animatePlayerOptionViewFadeOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    private func animateButtonDownward() {
        
        UIView.animate(withDuration: 0.7, delay: 0.2, options: .curveEaseInOut, animations: {
            self.loginButton.center.y = self.view.center.y * 1.8
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    private func animateButtonUpward() {
        
        UIView.animate(withDuration: 0.7, delay: 0.2, options: .curveEaseInOut, animations: {
            self.loginButton.center.y = self.view.center.y
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    private func animatePlayerOptionView() {
        
        UIView.animate(withDuration: 0.7, delay: 0.7, options: .curveEaseOut, animations: {
            self.playerOptionView.alpha = 1.0
            self.playerOptionView.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }

    private func animatePlayerOptionViewFadeOut() {
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.playerOptionView.alpha = 0.0
            self.playerOptionView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: nil)
        
    }
    
    func addGameToFirebase(with roomName: String) {
        firebaseModel.hostedGame(with: roomName)
    }
    
    
    func hostButtonTapped() {
       
        let alert = HostGameAlertController(title: "Host Game", message: nil, preferredStyle: .alert)
        var roomNameTF  : UITextField!
        alert.addTextField { (textField) in
            textField.placeholder = "Enter room name"
            roomNameTF = textField
        }
        alert.beginAppearanceTransition(true, animated: true)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: { action in
            if let roomName = roomNameTF.text {
                self.addGameToFirebase(with: roomName)
                self.goToHostGameVC(roomName: roomName)
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func joinButtonTapped() {
 
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "joinGameVC") as! JoinGameViewController
        let navigationVC = UINavigationController(rootViewController: vc)
        present(navigationVC, animated: true, completion: nil)
        
    }
    
    private func goToHostGameVC(roomName: String) {
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "hostVC") as! HostGameViewController
        vc.host = roomName
        vc.hostPlayer = true
        let navigationVC = UINavigationController(rootViewController: vc)
        present(navigationVC, animated: true, completion: nil)
    }
    
}

