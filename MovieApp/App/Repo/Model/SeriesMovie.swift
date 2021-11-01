//
//  SeriesMovie.swift
//  MovieApp
//
//  Created by Ishipo on 03/10/2021.
//

import Foundation
import SwiftyJSON
class SeriesMovieResponse {
    var results = [SeriesMovie]()
    
    required init? (_ json : JSON) {
        results = json["results"].arrayValue.map({SeriesMovie($0)!})
    }
    
}
public class SeriesMovie {
    var id : Int?
    var name : String?
    var poster_path : String?
    var parts = [Movies]()
    
    required init? (_ json : JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        poster_path = json["poster_path"].stringValue
        parts = json["parts"].arrayValue.map{Movies($0)!}
    }
}
