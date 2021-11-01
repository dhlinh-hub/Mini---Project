//
//  SeriesCell.swift
//  MovieApp
//
//  Created by Ishipo on 03/10/2021.
//

import UIKit

class SeriesCell: UICollectionViewCell {
    
    @IBOutlet weak var imgBackGroud: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI (_ series : SeriesMovie){
        
        lblTitle.text = series.name
        
        if let path = series.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
            imgBackGroud.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }

    }
}
