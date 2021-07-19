//
//  Credit.swift
//  MovieApp
//
//  Created by Ishipo on 28/06/2021.
//

import Foundation
import SwiftyJSON
class CreditResponse {
    var id: String?
    var person : Person?
    required public init? (_ json : JSON){
        id = json["id"].stringValue
        person = Person(json["person"])
        
    }
    
}
class Person {
    var id : Int?
    var profile_path : String?
    var known_for = [Movies]()
    
    required public init? (_ json : JSON){
        id = json["id"].intValue
        profile_path = json["profile_path"].stringValue
        known_for = json["known_for"].arrayValue.map({Movies($0)!})
    }
}



