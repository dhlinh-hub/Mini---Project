//
//  File.swift
//  MovieApp
//
//  Created by Ishipo on 19/06/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

enum CollectionKeys : String {
    case top_rated
    case popular
    case upcoming
    case now_playing
}

enum GenresKey : String , CodingKey {
    case movie
    case tv
}

class DiscoverViewModel {
    var pageIndexMV = 1
    var pageIndexTV = 100
    weak var delegate : DiscoverViewModelDelegate?
    var data = [Movies]()
    var genre = [Genres]()
    
    func getMovies(_ page: Int) {
        delegate?.showLoading()
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&with_watch_monetization_types=flatrate")
        AF.request(url!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let movies = MovieResponse(json)
                if let data = movies?.results {
                    self.data.append(contentsOf: data)
                    self.delegate?.updateMovies(self.data)
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
    
    func getAllGenre(_ key : GenresKey) {
        delegate?.showLoading()
        let url = URL(string: "https://api.themoviedb.org/3/genre/\(key.rawValue)/list?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US")
        AF.request(url!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let genres = GenresReponse(json)
                if let data = genres?.genres {
                    self.genre.append(contentsOf: data)
                    self.delegate?.updateGenres(self.genre)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.delegate?.hideLoading()
                }
            }
        })
        
    }
    
    
    
    public func handleSegment(_ index : Int) {
        if index == 0 {
            getAllGenre(.movie)
            getMovies(pageIndexMV)
        } else {
            getMovies(pageIndexTV)
            getAllGenre(.tv)
        }
        data.removeAll()
        genre.removeAll()
        pageIndexMV = 1
        pageIndexTV = 100
        
        
    }
    
    public func scrollAppendData(_ index : Int) {
        if index == 0 {
            if pageIndexMV <= 100 {
                pageIndexMV += 1
                getMovies(pageIndexMV)
            }
        } else {
            if pageIndexTV >= 100 {
                pageIndexTV += 1
                getMovies(pageIndexTV)
            }            
        }
    }
}

public protocol DiscoverViewModelDelegate : AnyObject {
    func updateMovies(_ movies: [Movies])
    func updateGenres(_ genres: [Genres])
    func showLoading()
    func hideLoading()
}
