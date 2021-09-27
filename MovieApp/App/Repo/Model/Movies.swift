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
    var vote_average : Double?
    var vote_count :Int?
    var popularity : Double?
    var bookmark = false
    var genres = [Genres]()
    var homepage : String?
    var imdb_id : String?
    var runtime : Int?
    var tagline : String?
    
    required public init? ( _ json: JSON){
        id = json["id"].intValue
        title = json["title"].stringValue
        overview = json["overview"].stringValue
        poster_path = json["poster_path"].stringValue
        release_date = json["release_date"].stringValue
        vote_average = json["vote_average"].doubleValue
        vote_count = json["vote_count"].intValue
        popularity = json["popularity"].doubleValue
        bookmark = json["bookmark"].isEmpty
        genres = json["genres"].arrayValue.map{Genres($0)!}
        imdb_id = json["imdb_id"].stringValue
        homepage = json["homepage"].stringValue
        runtime = json["runtime"].intValue
        tagline = json["tagline"].stringValue
        
    }
    
    
}

