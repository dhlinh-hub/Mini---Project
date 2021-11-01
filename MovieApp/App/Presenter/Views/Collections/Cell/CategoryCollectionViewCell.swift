//
//  CategoryCollectionViewCell.swift
//  MovieApp
//
//  Created by Ishipo on 20/09/2021.
//

import UIKit
import Kingfisher

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgBackGround: UIImageView!
    @IBOutlet weak var lblOverview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupUI (collec: Collections) {
        imgBackGround.image = UIImage(named: collec.image!)
        lblOverview.text = collec.discrip
    }
    
   
}
