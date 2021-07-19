//
//  Models.swift
//  MovieApp
//
//  Created by Ishipo on 18/06/2021.
//

import Foundation
import SwiftyJSON

class MovieResponse {
    var results = [Movies]()
    
    required public init? (_ json : JSON){
        results = json["results"].arrayValue.map{Movies($0)!}
    }
}



public class Movies {
    var id : Int?
    var title : String?
    var overview : String?
    var poster_path : String?
    var release_date : String?
    var video : Bool?
    var adult : Bool?
    var vote_average : Double?
    var vote_count :Int?
    var popularity : Double?
    var bookmark = false
    
    
    
    
    required public init? ( _ json: JSON){ // required ở đây có ý nghĩa mọi lớp con phải thực thi hàm khởi tạo này
        id = json["id"].intValue
        title = json["title"].stringValue
        overview = json["overview"].stringValue
        poster_path = json["poster_path"].stringValue
        release_date = json["release_date"].stringValue
        video = json["video"].boolValue
        adult = json["adult"].boolValue
        vote_average = json["vote_average"].doubleValue
        vote_count = json["vote_count"].intValue
        popularity = json["popularity"].doubleValue
        bookmark = json["bookmark"].isEmpty
        
    }
    
    
}

