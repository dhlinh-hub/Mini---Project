//
//  File.swift
//  MovieApp
//
//  Created by Ishipo on 19/06/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class MoviesViewModels {
    var pageIndexMV = 1
    var pageIndexTV = 1
    var vc : DiscoverViewController?
    weak var delegate : MoviesViewModelsDelegate?
    
    var dataMV = [Movies]()
    var dataTV = [Movies]()
    
    
    
    func getMovies(_ page : Int) {
        delegate?.showLoading()
        let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US&page=\(page)" )
        AF.request(url!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { response in
            switch response.result {
            
            case .success(let value):
                let json = JSON(value)
                let movies = MovieResponse(json)
                if let data = movies?.results {
                    self.dataMV.append(contentsOf: data)
                    
                    self.delegate?.updateMovies(self.dataMV)
                    DispatchQueue.main.async {
                        self.delegate?.hideLoading()
                    }
                }
                
            case .failure( let error):
                print(error)
                DispatchQueue.main.async {
                    self.delegate?.hideLoading()
                }
            }
        })
        
    }
    
    
    public func getTVSHows(_ page : Int){
        
        delegate?.showLoading()
        let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US&page=\(page)" )
        let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
        
        queue.async {
            AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                
                case .success(let value):
                    let json = JSON(value)
                    let movies = MovieResponse(json)
                    guard let data = movies?.results else { return}
                    self.dataTV.append(contentsOf: data)
                    self.delegate?.updateTVShow(self.dataTV)
                    DispatchQueue.main.async {
                        self.delegate?.hideLoading()
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self.delegate?.hideLoading()
                    }
                }
            })
        }
    }
    
    
    public func handleSegment() {
        if indexSegment() == 0 {
            getMovies(pageIndexMV)
            delegate?.scrollToTop()
            
        }else {
            getTVSHows(pageIndexTV)
            delegate?.scrollToTop()
            
        }
    }
    func indexSegment () -> Int {
        return (vc!.segmentControl.selectedSegmentIndex)
    }
    
    public func scrollAppendData() {
        
        if indexSegment() == 0 {
            if pageIndexMV <= 100 {
                pageIndexMV = pageIndexMV + 1
                getMovies(pageIndexMV)
            }
        }else {
            if pageIndexTV <= 100 {
                pageIndexTV = pageIndexTV + 2
                getTVSHows(pageIndexTV)
            }            
        }
    }
}

public protocol MoviesViewModelsDelegate : AnyObject {
    func scrollToTop()
    func updateMovies(_ movies: [Movies])
    func updateTVShow(_ tvShows: [Movies])
    func showLoading()
    func hideLoading()
}
