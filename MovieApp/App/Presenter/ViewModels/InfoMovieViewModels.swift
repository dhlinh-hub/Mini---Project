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

class InfoMovieViewModels  {
  
  weak var delegate : InfoMovieViewModelsDelegate?
  var vc :InfoFilmViewController!
  var idC = 1
  var idSession : String?
  var star : Double?
  
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
            self!.vc.collectionView.isHidden = true
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
            self!.vc.collectionView.isHidden = true
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
  
  public func creatSession () {
    
    let urlRequest = URL(string: "https://api.themoviedb.org/3/authentication/session/new?api_key=999fdf2ff164b33bed4aea14fa846a19")
    let param =  [ "request_token" : "ebc06d03b446ff41656259d674f6a812654be7d2" ]
    AF.request(urlRequest!, method: .post, parameters: param , encoding: JSONEncoding.default , headers: .default).responseJSON(completionHandler: {
      respon in
      switch respon.result {
      
      case .success( let value):
        print("\(respon)")
        let json = JSON(value)
        let sessionID = json["session_id"].stringValue
        print(sessionID)
        break
      case .failure( let error):
        print(error.localizedDescription)
        break
      }
      
    })
  }
  
  
  public func postRatingMovie ( _ movie : Movies) {
//    print("\(movie.id ?? 0)")
    let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id ?? 0)/rating?api_key=999fdf2ff164b33bed4aea14fa846a19&guest_session_id=6eea3ffc75a47baa44689cae182a4ab7")
    let param =  [ "value" : 6.0 ]
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
                      "bookmark" : movie.bookmark
      ] as [String : Any]
      let uid = Auth.auth().currentUser?.uid
      Database.database().reference().child("user").child(uid!).child("List").child("\(movie.id ?? 0)").setValue(userData)
      
    }
    movie.bookmark = !movie.bookmark
  }
  
  
  
  
  
}
protocol InfoMovieViewModelsDelegate: AnyObject {
  func updateCast( _ cast : [Cast])
  func stateVideo ( _ video : Videos )
  func updateSimilarMovie ( _ similarMovies : [Movies])
  func saveRating (_ rate : Double )
  
  //MARK : Favorite
  func updateCastR ( _ cast : [Cast])
  func stateVideoR ( _ video : Videos)
  func updateSimilarMovieR ( _ movies : [Movies])
  func hiddenSimilarMovieCollection()
  func hiddenVideoButton()
  func bookMarkIsSelect ()
  func bookMarkDeSelect ()
  func showLoading()
  func hideLoading()
  
  
  
}
