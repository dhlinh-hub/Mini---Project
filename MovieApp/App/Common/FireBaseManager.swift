//
//  FireBaseManager.swift
//  MovieApp
//
//  Created by Ishipo on 23/06/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FireBaseManager {
    
    static let shared = FireBaseManager()
    
    internal func login(_ email: String, _ password: String , completion: @escaping ((_ success: Bool) -> Void) ){
        Auth.auth().signIn(withEmail: email, password: password, completion: {(userResult, error) in
            if let error = error {
                print("\(error)")
                completion(false)
            }else {
                completion(true)
                
            }
        })
    }
    
    
    //Mark: register
    internal func register(_ email: String, _ password: String,_ name : String ,completion: @escaping ((_ success: Bool) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { (userResutl, error) in
            if let user = userResutl?.user {
                let userData = [ "id": "\(user.uid)",
                                 "user_name": name,
                                 "email": email,
                                 "image" : "" ,
                ] as [String : Any]
                
                let ref = Database.database().reference()
                let userRef = ref.child("user").child(user.uid)
                userRef.setValue(userData)
                
                completion(true)
            } else {
                print("Error: \(error!)")
                completion(false)
            }
        }
    }
    
    
    
    internal func logout(completion: @escaping ((_ success: Bool) -> Void)){
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch let logOutError as NSError {
            print("Error: \(logOutError)")
            completion(false)
        }
    }
    
    
    
   internal func firebaseSignInWithLink(credential: AuthCredential , completion: @escaping ((_ success: Bool) -> Void) ) {
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                debugPrint("APP: there has been an error signing into firebase, perhaps another account with same email")
                debugPrint("APP: \(String(describing: error))")
                
                // if existing email, try linking
                Auth.auth().currentUser?.link(with: credential, completion: { (user, error) in
                    if error != nil {
                        debugPrint("APP: there has been an error signing into firebase")
                        debugPrint("APP: \(String(describing: error))")
                    }
                    else {
                        debugPrint("APP: successfully signed into firebase")
                    }
                })
                completion(false)
            }
            else {
                let uid = user?.user.uid
                let image = user?.user.photoURL
                let ref = Database.database().reference().child("user").child(uid!)
                let userData = [ "id" : uid! ,
                                 "email" : "\(user?.user.email ?? "")" ,
                                 "image" : "\(image!)",
                                 "user_name" : "\(user?.user.displayName ?? "")",
                                 
                ] as [String : Any]
                
                ref.setValue(userData)
                completion(true)
                debugPrint("APP: successfully signed into firebase")
            }
        })
    }
    
    
    
    
}


