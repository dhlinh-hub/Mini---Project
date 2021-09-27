//
//  SimilarCollectionViewCell.swift
//  MovieApp
//
//  Created by Ishipo on 24/06/2021.
//

import UIKit
import Kingfisher

class SimilarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageMovie: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageMovie.layer.cornerRadius = 15
    }
    
    public func updateUI(_ movie: Movies){
        if let path = movie.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
            imageMovie.kf.setImage(with: url , placeholder: UIImage(named: "placeholder"))
        }
    }
}
