//
//  FavoriteViewModel.swift
//  MovieApp
//
//  Created by Ishipo on 03/07/2021.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON

class FavoriteViewModel {
    
    weak var delegate : FavoriteViewModelDelegate?
    var newData = [Movies]()
    
    
  public func fetchUser(completion: @escaping((_ success : Bool) -> Void)) {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("user").child(uid!).child("List").observe(.value, with: {(snapshot) in
            self.newData.removeAll()
            if let dictionary = snapshot.value as? [String : AnyObject] {
              if dictionary.count == 0 {
                completion(false)
              }else{
                self.delegate?.updateBagdeValue(dictionary.count)
                  for id in dictionary.keys {
                      if let data = dictionary["\(id)"] as? [String : Any] {
                          let json = JSON(data)
                          let movie = Movies(json)
                          self.newData.append(movie!)
                          self.delegate?.updateFavorite(self.newData)
                          
                         completion(true)
                      }
                      
                  }
              }
             
            }
            
        })
    completion(false)
    }
}

protocol FavoriteViewModelDelegate : AnyObject {
    func updateFavorite( _ movie : [Movies])
  func updateBagdeValue( _ count : Int)
    
}

