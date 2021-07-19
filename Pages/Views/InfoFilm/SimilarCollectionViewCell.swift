//
//  SimilarCollectionViewCell.swift
//  MovieApp
//
//  Created by Ishipo on 24/06/2021.
//

import UIKit
import Kingfisher

class SimilarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageMovie: UIImageView!
    var data : Movies? {
        didSet {
            if let data = data {
                if let path = data.poster_path {
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
                    imageMovie.kf.setImage(with: url)
                }else{
                    imageMovie.image = UIImage(named: "default")
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        imageMovie.layer.cornerRadius = 15
    }
    
}
