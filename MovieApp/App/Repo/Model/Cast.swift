//
//  Cast.swift
//  MovieApp
//
//  Created by Ishipo on 22/06/2021.
//

import Foundation
import SwiftyJSON

class CastResponse {
    var cast = [Cast]()
    
    required public init? (_ json : JSON){
        cast = json["cast"].arrayValue.map({Cast($0)!})
        
    }
    
}



class Cast {
    var id : Int?
    var name : String?
    var character : String?
    var profile_path : String?
    var credit_id : String?
    
    required public init? (_ json :JSON){
        id = json["id"].intValue
        name = json["name"].stringValue
        character = json["character"].stringValue
        profile_path = json["profile_path"].stringValue
        credit_id = json["credit_id"].stringValue
    }
    
}
