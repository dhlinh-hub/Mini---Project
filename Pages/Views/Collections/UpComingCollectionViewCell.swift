//
//  UpComingCollectionViewCell.swift
//  MovieApp
//
//  Created by Ishipo on 23/06/2021.
//

import UIKit

class UpComingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageBG: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var data : Movies? {
        didSet{
            if let data = data {
                if let path = data.poster_path {
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
                    imageBG.kf.setImage(with: url , placeholder: UIImage(named: "holder"))
                }
                titleLabel.text = "\(data.title!)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageBG.layer.cornerRadius = 10
        // Initialization code
    }

}
