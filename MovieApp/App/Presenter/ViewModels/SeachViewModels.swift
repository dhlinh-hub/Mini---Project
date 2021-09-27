//
//  SeachViewModels.swift
//  MovieApp
//
//  Created by Ishipo on 01/07/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class SeachViewModels {
    
    public weak var delegate : SeachViewModelsDelegate?
    var vc: SeachViewController?
    
    public func getSeachData(_ text : String){
        let urlRequest = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US&query=\(text)&page=1&include_adult=false" )
        let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
        
        queue.async {
            AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let movies = MovieResponse(json)
                    if let dataS = movies?.results {
                        self.delegate?.updateSeach(dataS)
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    func updateData( _ query : String)  {
        self.getSeachData(query)
    }
}

public protocol SeachViewModelsDelegate: AnyObject {
    func updateSeach( _ movies : [Movies] )
    func showLoading()
    func hideLoading()
   

}
