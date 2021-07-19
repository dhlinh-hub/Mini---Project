//
//  FollowingTableViewCell.swift
//  MovieApp
//
//  Created by Ishipo on 05/07/2021.
//

import UIKit
import Kingfisher

class FollowingTableViewCell: UITableViewCell {
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var onFollowCallBack: (() -> Void)? = nil
    var data : Users! {
        didSet{
            if let data = data {
                nameUser.text = "\(data.name!)"
                if data.currentFollowing == false {
                    self.configUnFollowButton()
                }else{
                    self.configFollowButton()
                }
                if let image = data.image {
                    let url = URL(string: image)
                    imageUser.kf.setImage(with: url , placeholder: UIImage(named: "default"))
                }

            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageUser.layer.cornerRadius = 25
        followButton.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

    }
    @IBAction func onFollowButton(_ sender: Any) {
        onFollowCallBack?()
        if data.currentFollowing == false {
            configUnFollowButton()
            

        } else {
            configFollowButton()

        }
    }
    
    func configFollowButton() {
        followButton.setTitle("Following", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
        followButton.layer.borderWidth = 0.5
        followButton.layer.borderColor = UIColor.white.cgColor
    }
    func configUnFollowButton() {
        followButton.setTitle("+ Follow", for: .normal)
        followButton.setTitleColor(.black, for: .normal)
        followButton.backgroundColor = .white
        followButton.layer.borderWidth = 0.5

    }
    
}
