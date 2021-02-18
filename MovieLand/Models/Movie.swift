//
//  Movie.swift
//  MovieLand
//
//  Created by Çağrı Portakalkökü on 18.02.2021.
//

import  UIKit
class Movie {
    let title:String?
    let posterPath:String?
    let overview:String?
    let voteCount:Int?
    let voteAverage:Double?
    var image:UIImage?
    var favorite:Bool = false
    
    init(from:[String:Any]) {
        self.title = from["title"] as? String
        self.posterPath = from["poster_path"] as? String
        self.overview = from["overview"] as? String
        self.voteCount = from["vote_count"] as? Int
        self.voteAverage = from["vote_average"] as? Double
    }
    
    func setFavoriteStatus(newStatus:Bool) {
        self.favorite =  newStatus
    }
    
    func setImage(image:UIImage) {
        self.image = image
    }
    
}
