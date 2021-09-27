//
//  DiscoverCollectionViewCell.swift
//  MovieApp
//
//  Created by Ishipo on 21/06/2021.
//

import UIKit
import Kingfisher

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageBackground: UIImageView!
    @IBOutlet private weak var labelRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    internal func updateUI(_ movie : Movies ){
        labelRating.text = "\(movie.vote_average!)"
        if let path = movie.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
            imageBackground.kf.setImage(with: url, placeholder: UIImage(named: "placeholder") )
        }
    }
}
