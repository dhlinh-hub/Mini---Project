//
//  CreditsCollectionViewCell.swift
//  MovieApp
//
//  Created by Ishipo on 09/07/2021.
//

import UIKit

class CreditsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageBG: UIImageView!
    @IBOutlet private weak var titleMovieLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    
    var data : Movies? {
        didSet{
            if let data = data {
              
                if let path = data.poster_path {
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
                    imageBG.kf.setImage(with: url,  placeholder: UIImage(named: "placeholder"))
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageBG.layer.cornerRadius = 10
    }
    
    func updateUI (_ movies : Movies) {
        titleMovieLabel.text = movies.title
        countLabel.text = "\(movies.vote_average!)"
        if let path = movies.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
            imageBG.kf.setImage(with: url,  placeholder: UIImage(named: "placeholder"))
        }
    }
    
}
