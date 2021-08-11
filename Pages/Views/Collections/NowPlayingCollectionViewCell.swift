//
//  NowPlayingCollectionViewCell.swift
//  MovieApp
//
//  Created by Ishipo on 23/06/2021.
//

import UIKit
import Kingfisher

class NowPlayingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBG: UIImageView!
    var data : Movies? {
        didSet{
            if let data = data {
                if let path = data.poster_path {
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
               
                imageBG.kf.setImage(with: url)
                }
            }
        }
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageBG.layer.cornerRadius = 15
    }

}
