//
//  CreditsCollectionViewCell.swift
//  MovieApp
//
//  Created by Ishipo on 09/07/2021.
//

import UIKit

class CreditsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBG: UIImageView!
    @IBOutlet weak var titleMovieLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    
    var data : Movies? {
        didSet{
            if let data = data {
                titleMovieLabel.text = "\(data.title!)"
                countLabel.text = "\(data.vote_average!)"
                if let path = data.poster_path {
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
                    imageBG.kf.setImage(with: url)
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        imageBG.layer.cornerRadius = 10
    }

}
