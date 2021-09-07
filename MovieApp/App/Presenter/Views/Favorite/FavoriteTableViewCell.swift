//
//  FavoriteTableViewCell.swift
//  MovieApp
//
//  Created by Ishipo on 23/06/2021.
//

import UIKit
import Kingfisher

class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet private weak var imageBG: UIImageView!
    @IBOutlet private weak var titleMovie: UILabel!
    
    var data : Movies? {
        didSet {
            if let data = data {
                if let path = data.poster_path {
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
                    imageBG.kf.setImage(with: url)
                }else {
                    imageBG.image = UIImage(named: "default")
                }
                titleMovie.text = "\(data.title ?? "")"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageBG.layer.cornerRadius = 20
        imageBG.layer.borderWidth = 0.2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
