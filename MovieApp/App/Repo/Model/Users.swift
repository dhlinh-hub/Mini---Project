//
//  Users.swift
//  MovieApp
//
//  Created by Ishipo on 04/07/2021.
//

import Foundation
import SwiftyJSON

class Users {
    var id : String?
    var name : String?
    var email : String?
    var image : String?
    var currentFollowing = false
    
    required public init? (_ json : JSON){
        id = json["id"].stringValue
        name = json["user_name"].stringValue
        email = json["email"].stringValue
        image = json["image"].stringValue
        currentFollowing = json["currentFollowing"].boolValue
    }
}

