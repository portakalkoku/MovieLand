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
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
