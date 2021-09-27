//
//  Genres.swift
//  MovieApp
//
//  Created by Ishipo on 19/09/2021.
//

import Foundation
import SwiftyJSON

class GenresReponse {
    var genres = [Genres]()
    
    required public init? (_ json : JSON){
        genres = json["genres"].arrayValue.map{Genres($0)!}
    }
}


public class Genres {
    var id : Int?
    var name : String?
    
    required public init? (_ json: JSON){
        id = json["id"].intValue
        name = json["name"].stringValue
    }
}
