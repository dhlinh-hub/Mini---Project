//
//  SeachSeriesMovieViewModel.swift
//  MovieApp
//
//  Created by Ishipo on 03/10/2021.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol SeachSeriesMovieViewModelDelegate : AnyObject {
    func updateData (_ series : [SeriesMovie])
}

class SeachSeriesMovieViewModel {
    weak var delegate : SeachSeriesMovieViewModelDelegate?
    
    
    public func seachData (_ text : String) {
        let url = URL(string: "https://api.themoviedb.org/3/search/collection?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US&query=\(text))&page=1")
        
        AF.request(url!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let repo = SeriesMovieResponse(json)
                if let seriees = repo?.results {
                self.delegate?.updateData(seriees)
                }
            case .failure(let err):
                print(err)

            }
        })
    }
    
    
}
