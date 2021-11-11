//
//  CollectionsViewModel.swift
//  MovieApp
//
//  Created by Ishipo on 05/07/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class CategoryViewModel {
    
   public weak var delegate : CategoryViewModelDelegate?
    
    public func getMovie(_ key: CollectionKeys){
        delegate?.showLoading()
        let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/\(key.rawValue)?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US&page=10" )
        let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
        queue.async {
            AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let movies = MovieResponse(json)
                    if let data = movies?.results {
                        self.delegate?.updateDataCategory(data)
                        self.delegate?.hideLoading()

                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    public func getSeriesDetail(_ serires : SeriesMovie){
        delegate?.showLoading()
        let urlRequest = URL(string:"https://api.themoviedb.org/3/collection/\(serires.id ?? 0)?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US" )
        let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
        queue.async {
            AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let movies = SeriesMovie(json)
                    if let data = movies?.parts {
                        self.delegate?.updateDataCategory(data)
                        self.delegate?.hideLoading()

                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}

protocol CategoryViewModelDelegate: AnyObject {
    func updateDataCategory(_ movie : [Movies] )
    func showLoading()
    func hideLoading()
}
