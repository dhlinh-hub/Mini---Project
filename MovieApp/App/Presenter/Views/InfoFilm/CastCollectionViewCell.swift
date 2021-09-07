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
    var data : Cast? {
        didSet {
            if let data = data {
                if let path = data.profile_path {
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
                    imageCast.kf.setImage(with: url, placeholder: UIImage(named: "default")) { start, end in
                    }
                }else {
                    imageCast.image = UIImage(named: "default")
                }
                nameCast.text = "\(data.name!)"
                directorCast.text = "\(data.character!)"
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCast.layer.cornerRadius = 25
    }
    
}
