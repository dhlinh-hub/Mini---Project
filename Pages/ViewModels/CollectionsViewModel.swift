//
//  CollectionsViewModel.swift
//  MovieApp
//
//  Created by Ishipo on 05/07/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class CollectionsViewModel {
  
  public weak var delegate : CollectionsViewModelDelegate?
  
  public func getNowPlaying(){
    delegate?.showLoading()
    let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US&page=10" )
    let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
    
    queue.async {
      AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { (response) in
        switch response.result {
        case .success(let value):
          let json = JSON(value)
          let movies = MovieResponse(json)
          
          if let dataS = movies?.results {
            self.delegate?.updateNowPlaying(dataS)
            DispatchQueue.main.async {
              self.delegate?.hideLoading()
            }
            
          }
        case .failure(let error):
          print(error)
        }
      })
    }
  }
  
  
  public func getPopular(){
    delegate?.showLoading()
    
    let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US&page=2" )
    let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
    queue.async {
      AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { (response) in
        switch response.result {
        case .success(let value):
          let json = JSON(value)
          let movies = MovieResponse(json)
          if let dataS = movies?.results {
            self.delegate?.updatePopular(dataS)
            DispatchQueue.main.async {
              self.delegate?.hideLoading()
            }
          }
        case .failure(let error):
          print(error)
        }
      })
    }
  }
  
  
  public func getUpComing(){
    delegate?.showLoading()
    
    let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US&page=7" )
    let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
    
    queue.async {
      AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { (response) in
        switch response.result {
        case .success(let value):
          print(value)
          let json = JSON(value)
          let movies = MovieResponse(json)
          if let dataS = movies?.results {
            self.delegate?.updateUpComing(dataS)
            DispatchQueue.main.async {
              self.delegate?.hideLoading()
            }
          }
        case .failure(let error):
          print(error)
        }
      })
    }
  }
  
  
  public func getTopRate(){
    delegate?.showLoading()
    
    let urlRequest = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=999fdf2ff164b33bed4aea14fa846a19&language=en-US&page=2" )
    let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
    queue.async {
      AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { (response) in
        switch response.result {
        case .success(let value):
          let json = JSON(value)
          let movies = MovieResponse(json)
          if let dataS = movies?.results {
            self.delegate?.updateTopRated(dataS)
            DispatchQueue.main.async {
              self.delegate?.hideLoading()
            }
          }
        case .failure(let error):
          print(error)
        }
      })
    }
  }
  
}
protocol CollectionsViewModelDelegate: AnyObject {
  func updateNowPlaying(_ movie : [Movies] )
  func updateUpComing(_ movie : [Movies] )
  func updatePopular(_ movie : [Movies] )
  func updateTopRated(_ movie : [Movies] )
  func showLoading()
  func hideLoading()
  
  
  
  
  
}
