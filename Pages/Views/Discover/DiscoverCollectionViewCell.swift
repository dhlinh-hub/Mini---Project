//
//  DiscoverCollectionViewCell.swift
//  MovieApp
//
//  Created by Ishipo on 21/06/2021.
//

import UIKit
import Kingfisher

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBackground: UIImageView!
    
    @IBOutlet weak var labelRating: UILabel!
    
    var data : Movies? {
        didSet {
            if let data = data {
                if let path = data.poster_path {
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
                    imageBackground.kf.setImage(with: url )
                    
                }
                
                labelRating.text = "\(data.vote_average!)"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
