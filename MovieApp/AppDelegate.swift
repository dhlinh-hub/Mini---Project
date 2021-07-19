//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Ishipo on 17/06/2021.
//

import UIKit
import FirebaseCore
import FirebaseAuth
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()

    window = UIWindow(frame: UIScreen.main.bounds)
    var rootVC : UIViewController!
    
    if Auth.auth().currentUser != nil {
      rootVC = MainTabbar.setupTabar()
    }else {
      rootVC = LoginViewController()
    }
    window?.rootViewController = rootVC
    window?.makeKeyAndVisible()
    return true
  }
  
  
}
