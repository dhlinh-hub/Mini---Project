//
//  LoginViewController.swift
//  MovieApp
//
//  Created by Ishipo on 18/06/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class LoginViewController: UIViewController {
  
  
  @IBOutlet weak var googleView: UIView!
  @IBOutlet weak var twitterView: UIView!
  @IBOutlet weak var facebookView: UIView!
  @IBOutlet weak var appleView: UIView!
  @IBOutlet weak var appleButton: UIButton!
  @IBOutlet weak var facebookButton: UIButton!
  @IBOutlet weak var twitterButton: UIButton!
  @IBOutlet weak var googleButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupConfig()
    GIDSignIn.sharedInstance().clientID = "556537741507-gp7l3fplbrngknlhpdo2cd5fdrk8p6ds.apps.googleusercontent.com"
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance().presentingViewController = self
    
    
  }
  private func setupConfig() {
    appleView.layer.cornerRadius = 25
    twitterView.layer.cornerRadius = 25
    facebookView.layer.cornerRadius = 25
    googleView.layer.cornerRadius = 25
    appleButton.addTarget(self, action: #selector(tapGesture), for: .touchUpInside)
    
    
  }
  
  @IBAction func googleSignIn(_ sender: Any) {
    GIDSignIn.sharedInstance().signIn()
    
    
  }
  @objc func tapGesture() {
    let vc = SignInViewController()
    vc.modalPresentationStyle = .fullScreen
    self.present(vc, animated: true, completion: nil)
    
  }
  func showLoading() {
    LoadingView.shared.showProgressHubOnMainThread()

  }
  
  func gotoHome() {
    let vc = MainTabbar.setupTabar()
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true, completion: nil)
    
  }
  
  
}

extension LoginViewController : GIDSignInDelegate {
  
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    
    if error != nil {
      return
    }
    guard let authentication = user.authentication else { return }
    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                   accessToken: authentication.accessToken)
    FireBaseManager.shared.firebaseSignInWithLink(credential: credential, completion: { state in
      if state {
        self.gotoHome()
      }else {
        
      }
    })
    
    
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

    return GIDSignIn.sharedInstance().handle(url)
    
  }
  
  
}

