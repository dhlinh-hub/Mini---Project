//
//  UserViewModel.swift
//  MovieApp
//
//  Created by Ishipo on 05/07/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON


class UserViewModel {
    public weak var delegate : UserViewModelDelegate?
    let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference().child("user")
    var lisUser = [Users]()
    var userFollowing = [Users]()
    var userFollower = [Users]()
    
    public func fetchAllUser() {
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                self.lisUser.removeAll()
                for userId in dictionary.keys {
                    if userId == self.uid  {
                        
                    }else {
                        if let data = dictionary["\(userId)"] as? [String: AnyObject]{
                            let json = JSON(data)
                            let userData = Users(json)
                            self.lisUser.append(userData!)
                            self.delegate?.dataAllUser(self.lisUser)
                            
                            
                        }
                        
                    }
                }
                
            }
        })
        
    }
    
    
    public func fetchUserFollowing() {
        ref.child(uid!).child("follwing").observe(.value, with: {snap in
            
            if let dic = snap.value as? [String:AnyObject] {
                self.userFollowing.removeAll()
                for item in dic.keys {
                    if let data = dic["\(item)"] as? [String : AnyObject] {
                        let json = JSON(data)
                        if let data = Users(json) {
                            self.userFollowing.append(data)
                            self.delegate?.dataUserFollowing(self.userFollowing)
                        }
                        
                    }
                }
                
            }
        })
    }
    public func fetchUserFollower() {
        
        ref.child(uid!).child("follower").observeSingleEvent(of:.value, with: {snap in
            if let dic = snap.value as? [String:AnyObject] {
                self.userFollower.removeAll()
                for item in dic.keys {
                    self.ref.observeSingleEvent(of:.value, with: { snapshot in
                        if let dictionary = snapshot.value as? [String:AnyObject] {
                            if let data = dictionary["\(item)"] as? [String : AnyObject]{
                                let json = JSON(data)
                                if let user = Users(json) {
                                    self.userFollower.append(user)
                                    self.delegate?.dataUserFollower(self.userFollower)
                                    
                                }
                            }
                        }
                    })
                }
            }
        })
    }
    
    
    public func saveUserFollowing(_ user : Users) {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("user").child(uid!)
        let userData = [ "id" : user.id ?? "",
                         "user_name" : user.name ?? "",
                         "email" : user.email ?? "" ,
                         "image" : user.image ?? "",
                         "currentFollowing" : true
        ] as [String : Any]
        
        ref.child("follwing").child("\(user.id ?? "id")").setValue(userData, withCompletionBlock: { _ , _ in
            Database.database().reference().child("user").child("\(user.id ?? "")").child("currentFollowing").setValue(true)
            
        })
        Database.database().reference().child("user").child("\(user.id ?? "")").child("follower").child(uid!).setValue(uid!)
        
        
    }
    
    func unfollowUser( _ user : Users) {
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("user").child(uid!)
        let ref2 = Database.database().reference().child("user").child("\(user.id ?? "")")
        
        ref2.child("follower").observeSingleEvent(of: .value, with: { snapshot in
            if let diC = snapshot.value as? [String : AnyObject] {
                for id in diC.keys {
                    if id == uid {
                        ref2.child("follower").child("\(id)").removeValue()
                        
                    }
                    
                }
            }
            
        })
        
        ref2.child("currentFollowing").setValue(false)
        
        ref.child("follwing").observeSingleEvent(of: .value, with: { snapshot in
            if let dic = snapshot.value as? [String : AnyObject] {
                for id in dic.keys {
                    if id == "\(user.id ?? "")" {
                        ref.child("follwing").child("\(id)").removeValue()
                        
                    }
                    
                }
            }
        })
        
    }
    
    public func onFollow( _ user : Users) {
        if user.currentFollowing == false{
            saveUserFollowing(user)
        }else {
            unfollowUser(user)
        }
        user.currentFollowing = !user.currentFollowing
    }
}

protocol UserViewModelDelegate : AnyObject {
    func dataAllUser( _ user : [Users])
    func dataUserFollowing ( _ user : [Users])
    func dataUserFollower ( _ user : [Users])
    
}
