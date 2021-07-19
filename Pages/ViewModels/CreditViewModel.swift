//
//  CreditViewModel.swift
//  MovieApp
//
//  Created by Ishipo on 09/07/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol CreditViewModelDelegate: AnyObject {
  func updateInfoCast( _ movie : [Movies] )
  func updateCountMovie ( _ count : Int )
  func showLoading()
  func hideLoading()
}


class CreditViewModel {
  public weak var delegate : CreditViewModelDelegate?
  var count : Int?
  public func getList( _ cast : Cast) {
    delegate?.showLoading()
    let urlRequest = URL(string: "https://api.themoviedb.org/3/credit/\(cast.credit_id ?? "5d2b2910be4b3612f5ab00f6")?api_key=999fdf2ff164b33bed4aea14fa846a19" )
    let queue = DispatchQueue(label: "com.queue", qos: .background, attributes: .concurrent)
    queue.async {
      AF.request(urlRequest!, method: .get, encoding: URLEncoding.httpBody, headers: .default).responseJSON(completionHandler: { (response) in
        switch response.result {
        case .success(let value):
          print(value)
          let json = JSON(value)
          let credit = CreditResponse(json)
          let person = credit?.person
          if let list = person?.known_for {
            self.delegate?.updateInfoCast(list)
            
            self.count = list.count
            self.delegate?.updateCountMovie(self.count!)
            self.delegate?.hideLoading()
            
          }
        case .failure(let error):
          print(error)
        }
      })
    }
    
  }
  
}



