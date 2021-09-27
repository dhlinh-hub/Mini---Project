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
    
    
    @IBOutlet private weak var googleView: UIView!
    @IBOutlet private weak var twitterView: UIView!
    @IBOutlet private weak var facebookView: UIView!
    @IBOutlet private weak var appleView: UIView!
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = "556537741507-gp7l3fplbrngknlhpdo2cd5fdrk8p6ds.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        
        
    }
 
    
    @IBAction func loginAccountAction(_ sender: Any) {
        let vc = SIAccountViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginFBAction(_ sender: Any) {
        print("FB")
    }
    
    @IBAction func loginPhoneAction(_ sender: Any) {
        print("Phone")
    }
    
    @IBAction func loginGoogleAction(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    private func gotoHome() {
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

        LoadingView.shared.showProgressHubOnMainThread()
        FireBaseManager.shared.firebaseSignInWithLink(credential: credential,
                                                        completion: { state in
            if state {
                self.gotoHome()
            }
        })
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}

