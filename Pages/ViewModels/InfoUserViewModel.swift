//
//  InfoUserViewModel.swift
//  MovieApp
//
//  Created by Ishipo on 06/07/2021.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON

protocol InfoUserViewModelDelegate : AnyObject {
  func updateListFavorite ( _ movie : [Movies])
  func updateCountFollowing ( _ index : Int)
  func updateCountFollower ( _ index : Int)
  func showLoading()
  func hideLoading()
  
}

class InfoUserViewModel {
  
  public weak var delegate : InfoUserViewModelDelegate?
  var data = [Movies]()
  let ref = Database.database().reference().child("user")
  var countFollowing : Int?
  var countFollower : Int?
  
  public func fetchLisFavorite(_ user : Users) {
    Database.database().reference().child("user").child("\(user.id ?? "")").child("List").observe(.value, with: { snap in
      if let dictionary = snap.value as? [String : AnyObject] {
        for item in dictionary.keys {
          if let movies = dictionary["\(item)"] as? [String : AnyObject] {
            let json = JSON(movies)
            let movie = Movies(json)
            self.data.append(movie!)
            
            self.delegate?.updateListFavorite(self.data)
          }
          
        }
        
      }
    })
  }
  public func fetchCountFollowingUser( _ user : Users) {
    ref.child("\(user.id!)").child("follwing").observe(.value, with: {(snapshot) in
      if let dictionary = snapshot.value as? [String : AnyObject] {
        self.countFollowing = dictionary.count
        self.delegate?.updateCountFollowing(self.countFollowing!)
        
      }
    })
  }
  
  public func fetchCountFollowerUser(_ user : Users, completion : @escaping ((_ success : Bool) -> Void) ) {
    
    ref.child("\(user.id!)").child("follower").observe(.value, with: {(snapshot) in
      if let dictionary = snapshot.value as? [String : AnyObject] {
        self.countFollower = dictionary.count
        self.delegate?.updateCountFollower(self.countFollower!)
        completion(true)
      }
      
    })
    completion(false)
  }
  
}
