//
//  Videos.swift
//  MovieApp
//
//  Created by Ishipo on 22/06/2021.
//

import Foundation
import  SwiftyJSON

class VideoResponse {
    var results = [Videos]()
    
    required public init? (_ json : JSON){
        results = json["results"].arrayValue.map({Videos($0)!})
//        results = json["results"].object as? Videos
    }
        
    
}

class Videos {
    var id : String?
    var key : String?
    var name : String?
    var type : String?
    
    
    required public init? (_ json: JSON){
        id = json["id"].stringValue
        key = json["key"].stringValue
        name = json["name"].stringValue
        type = json["type"].stringValue
    }
    
}
