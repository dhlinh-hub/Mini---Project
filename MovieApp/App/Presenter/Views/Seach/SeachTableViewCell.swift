//
//  SeachTableViewCell.swift
//  MovieApp
//
//  Created by Ishipo on 21/06/2021.
//

import UIKit
import Kingfisher

class SeachTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var imageMovie: UIImageView!
    @IBOutlet private weak var titleMovie: UILabel!
    @IBOutlet private weak var releaseDateMovie: UILabel!
    @IBOutlet private weak var viewMovie: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func updateUI (_ movie : Movies) {
        titleMovie.text = "\(movie.title!)"
        releaseDateMovie.text = "Popular: \(movie.popularity!)"
        viewMovie.text = "\(movie.release_date!)"
        
        if let path = movie.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
            imageMovie.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        
    }
    
}
