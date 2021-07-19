//
//  SeachTableViewCell.swift
//  MovieApp
//
//  Created by Ishipo on 21/06/2021.
//

import UIKit
import Kingfisher

class SeachTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var releaseDateMovie: UILabel!
    @IBOutlet weak var viewMovie: UILabel!
    
    var data : Movies? {
        didSet{
            if let data = data {
                if let path = data.poster_path {
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
                    imageMovie.kf.setImage(with: url , placeholder: UIImage(named: "holder"))
                }
                
                titleMovie.text = "\(data.title!)"
                releaseDateMovie.text = "View: \(data.popularity!)"
                viewMovie.text = "\(data.release_date!)"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //        imageMovie.layer.cornerRadius = 10
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
