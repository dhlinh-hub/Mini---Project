//
//  ProfileViewModel.swift
//  MovieApp
//
//  Created by Ishipo on 04/07/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON
import FirebaseStorage

class ProfileViewModel {
    
    public weak var delegate : ProfileViewModelDelegate?
    let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference().child("user")
    var countFollowing = 0
    var countFollower : Int?
    
    
    public func fetchUser() {
        delegate?.showLoading()
        ref.observe(.value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                for i in dictionary.keys {
                    if i == self.uid {
                        let data = dictionary["\(i)"] as? [String : AnyObject]
                        let json = JSON(data!)
                        let userData = Users(json)
                        self.delegate?.updateInfoUser(userData!)
                        self.delegate?.hideLoading()
                        
                    }
                }
            }
        })
        
    }
  public func fetchCountFollowingUser( completion : @escaping ((_ success : Bool) -> Void)) {

        ref.child(uid!).child("follwing").observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                self.countFollowing = dictionary.count
            
                self.delegate?.updateCountFollowing(self.countFollowing)
              completion(true)
            }
        })
    completion(false)
    }
    
    public func fetchCountFollowerUser( completion : @escaping ((_ success : Bool) -> Void)) {

        ref.child(uid!).child("follower").observe(.value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                self.countFollower = dictionary.count
                self.delegate?.updateCountFollower(self.countFollower!)
                completion(true)
            }
            
        })
      completion(false)
    }
    public func resetAlluser() {
        
        ref.observe(.value, with: {snap in
            if let dic = snap.value as? [String: AnyObject] {
                for i in dic.keys {
                    self.ref.child("\(i)").child("currentFollowing").setValue(false)
                }
            }
        })
        
    }
    func randomStringWithLength(length: Int) -> NSString {
        let characters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString: NSMutableString = NSMutableString(capacity: length)
        
        for _ in 0..<length {
            let len = UInt32(characters.length)
            let rand = arc4random_uniform(len)
            randomString.appendFormat("%C", characters.character(at: Int(rand)))
        }
        return randomString
    }
    
    func uploadImage(image: UIImage) {
        let randomName = randomStringWithLength(length: 10)
        let imageData = image.jpegData(compressionQuality: 1.0)
        let uploadRef = Storage.storage().reference().child("images/profimg/\(randomName).jpg")
        _ = uploadRef.putData(imageData!, metadata: nil) { metadata,
                                                           error in
            if error == nil {
                uploadRef.downloadURL(completion: { url, error in
                    if let url = url , error == nil {
                        let urlString = url.absoluteString
                        let uid = Auth.auth().currentUser?.uid
                        Database.database().reference().child("user").child(uid!).child("image").setValue(urlString)
                    }
                })
            } else {
                //error
            }
        }
        
    }
    
}





protocol ProfileViewModelDelegate : AnyObject {
    func updateInfoUser( _ user : Users)
    func updateCountFollowing ( _ index : Int)
    func updateCountFollower ( _ index : Int)
    func showLoading()
    func hideLoading()
}
