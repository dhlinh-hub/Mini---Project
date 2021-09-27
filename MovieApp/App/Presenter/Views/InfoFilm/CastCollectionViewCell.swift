//
//  CastCollectionViewCell.swift
//  MovieApp
//
//  Created by Ishipo on 22/06/2021.
//

import UIKit
import Kingfisher

class CastCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageCast: UIImageView!
    @IBOutlet private weak var nameCast: UILabel!
    @IBOutlet private weak var directorCast: UILabel!
    @IBOutlet private weak var containerView: UIView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCast.layer.cornerRadius = 25
    }
    
    public func updateUI (_ cast : Cast){
            if let path = cast.profile_path {
                let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
                imageCast.kf.setImage(with: url, placeholder: UIImage(named: "default")) { start, end in
                }
          
            nameCast.text = "\(cast.name!)"
            directorCast.text = "\(cast.character!)"
        }
    }
}
