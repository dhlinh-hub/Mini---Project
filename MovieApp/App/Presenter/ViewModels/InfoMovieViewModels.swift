//
//  InfoMovieViewModels.swift
//  MovieApp
//
//  Created by Ishipo on 01/07/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import FirebaseAuth
import FirebaseDatabase
protocol InfoMovieViewModelsDelegate: AnyObject {
    func updateCast( _ cast : [Cast])
    func stateVideo ( _ video : Videos )
    func updateSimilarMovie ( _ similarMovies : [Movies])
    func infoMovie(_ movie : Movies)
    
    //MARK : Favorite
    func updateCastR ( _ cast : [Cast])
    func stateVideoR ( _ video : Videos)
    func updateSimilarMovieR ( _ movies : [Movies])
    func genresMoie (_ gen : [Genres])
    
    func hiddenSimilarMovieCollection()
    func hiddenCollectionView()
    func hiddenVideoButton()
    func bookMarkIsSelect ()
    func bookMarkDeSelect ()
    func showLoading()
    func hideLoading()

}


class InfoMovieViewModels  {
    
    weak var delegate : InfoMovieViewModelsDelegate?
    
    public func getMovieDetail( _ movie : Movies){
        delegate?.showLoading()
        let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id!)?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US")
        
        AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: {  respon in
            switch respon.result {
            
            case .success(let value):
                let json = JSON(value)
                let movie = Movies(json)
                self.delegate?.infoMovie(movie!)
                
                if let genre = movie?.genres {
                    self.delegate?.genresMoie(genre)
                    self.delegate?.hideLoading()
                }

            case .failure(let error):
                print(error.localizedDescription)
                
            }
        })
        
    }
    
    
    public func getCastData(_ data : Movies) {
        delegate?.showLoading()
        let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/\(data.id ?? 100)/credits?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US" )
        let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
        queue.async {
            
            AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { [weak self] (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let cast = CastResponse(json)
                    
                    if cast?.cast.count == 0 {
                        self?.delegate?.hiddenCollectionView()
                    }
                    if let data = cast?.cast{
                        self!.delegate?.updateCast(data)
                        self?.delegate?.hideLoading()
                        
                    } else {
                        
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
        
    }
    
    
    public func getVideo(_ data : Movies) {
        print("\(data.id ?? 00)")
        let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/\(data.id ?? 100)/videos?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US" )
        let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
        queue.async {
            AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { [weak self] (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let vd = VideoResponse(json)
                    if vd?.results.count == 0 {
                        self!.delegate?.hiddenVideoButton()
                    }else{
                        guard let data = vd?.results[0] else { return }
                        self!.delegate?.stateVideo(data)
                        
                    }
                    
                case .failure(let error):
                    print(error)
                }
            })
        }
        
    }
    
    public func getSimilarMovies(_ data : Movies) {
        let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/\(data.id ?? 100)/similar?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US&page=1" )
        let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
        queue.async {
            AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { [weak self] (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let similar = MovieResponse(json)
                    if similar?.results.count == 0 {
                        self!.delegate?.hiddenSimilarMovieCollection()
                        
                    }
                    guard let data = similar?.results else { return }
                    self!.delegate?.updateSimilarMovie(data)
                    
                case .failure(let error):
                    print(error)
                }
            })
        }
        
    }
    
    //MARK : Favorite screen goes inside
    
    public func getCastR(_ data : Movies) {
        let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/\(data.id ?? 100)/credits?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US" )
        let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
        queue.async {
            
            AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { [weak self] (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let cast = CastResponse(json)
                    if cast?.cast.count == 0 {
                        self!.delegate?.hiddenCollectionView()
                    }
                    if let data = cast?.cast{
                        self!.delegate?.updateCastR(data)
                    } else {
                        
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    public func getVideoR(_ data : Movies) {
        let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/\(data.id ?? 100)/videos?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US" )
        let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
        queue.async {
            AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { [weak self] (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let vd = VideoResponse(json)
                    if vd?.results.count == 0 {
                        self!.delegate?.hiddenVideoButton()
                    }else{
                        guard let data = vd?.results[0] else { return }
                        
                        self!.delegate?.stateVideoR(data)
                        
                        
                        
                    }
                    
                case .failure(let error):
                    print(error)
                }
            })
        }
        
    }
    
    public func getSimilarMoviesR(_ data : Movies) {
        
        let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/\(data.id ?? 100)/similar?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US&page=1" )
        let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
        queue.async {
            AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { [weak self] (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let similar = MovieResponse(json)
                    if similar?.results.count == 0 {
                        self!.delegate?.hiddenSimilarMovieCollection()
                    }
                    guard let data = similar?.results else { return }
                    self!.delegate?.updateSimilarMovieR(data)
                    
                case .failure(let error):
                    print(error)
                }
            })
        }
        
    }
    
    public func postRatingMovie ( _ movie : Movies , _ rate : Double) {
        let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id ?? 0)/rating?api_key=999fdf2ff164b33bed4aea14fa846a19&session_id=3fdbf928ded3e6c3f7bf0e2f100da0ae27a5c566")
        let param =  [ "value" : rate ]
        print("\(movie.id ?? 0)")
        print(param)
        AF.request(urlRequest!, method: .post, parameters: param as Parameters , encoding: JSONEncoding.default , headers: .default).responseJSON(completionHandler: {
            respon in
            switch respon.result {
            case .success(_):
                print("\(respon)")
                break
            case .failure( let error):
                print(error.localizedDescription)
                break
            }
        })
    }
    
    public func transitBookMark(_ movie : Movies) {
        if movie.bookmark {
            delegate?.bookMarkIsSelect()
            let userData = ["id" : movie.id ?? 0,
                            "title" : movie.title ?? "",
                            "overview": movie.overview ?? "" ,
                            "popularity" : movie.popularity ?? 0.0 ,
                            "poster_path" : movie.poster_path ?? "",
                            "release_date": movie.release_date ?? "",
                            "vote_average" : movie.vote_average ?? 0,
                            "vote_count" : movie.vote_count ?? 0,
                            "tagline" : movie.tagline!,
                            "runtime" : movie.runtime!,
                            "homepage": movie.homepage!,
                            "imdb_id": movie.imdb_id!,
                            "bookmark" : movie.bookmark
            ] as [String : Any]
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("user").child(uid!).child("List").child("\(movie.id ?? 0)").setValue(userData)
            
        }else {
            delegate?.bookMarkDeSelect()
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("user").child(uid!)
            
            ref.child("List").observe(.value, with: { snapshot in
                if let dic = snapshot.value as? [String : AnyObject] {
                    for id in dic.keys {
                        if id == "\(movie.id ?? 0)" {
                            ref.child("List").child("\(id)").removeValue()
                        }                        
                    }
                }
            })
            
        }
        movie.bookmark = !movie.bookmark
    }
    
    
    // data Favorite
    public func transitBookMarkR(_ movie : Movies) {
        if movie.bookmark{
            
            delegate?.bookMarkDeSelect()
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("user").child(uid!)
            
            ref.child("List").observe(.value, with: { snapshot in
                if let dic = snapshot.value as? [String : AnyObject] {
                    for id in dic.keys {
                        if id == "\(movie.id ?? 0)" {
                            ref.child("List").child("\(id)").removeValue()
                        }
                        
                    }
                }
            })
        } else {
            delegate?.bookMarkIsSelect()
            
            let userData = ["id" : movie.id ?? 0,
                            "title" : movie.title ?? "",
                            "overview": movie.overview ?? "" ,
                            "popularity" : movie.popularity ?? 0.0 ,
                            "poster_path" : movie.poster_path ?? "",
                            "release_date": movie.release_date ?? "",
                            "vote_average" : movie.vote_average ?? 0,
                            "vote_count" : movie.vote_count ?? 0,
                            "tagline" : movie.tagline!,
                            "runtime" : movie.runtime!,
                            "homepage": movie.homepage!,
                            "imdb_id": movie.imdb_id!,
                            "bookmark" : movie.bookmark

            ] as [String : Any]
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("user").child(uid!).child("List").child("\(movie.id ?? 0)").setValue(userData)
        }
        movie.bookmark = !movie.bookmark
    }
    
    
    
    
    
}
