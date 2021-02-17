//
//  MovieCollectionViewCell.swift
//  MovieLand
//
//  Created by Çağrı Portakalkökü on 17.02.2021.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    //view implementations
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 10 // rectangular border radius
        super.awakeFromNib()
        // Initialization code
    }

}

