//
//  MovieDetailsViewController.swift
//  MovieLand
//
//  Created by Çağrı Portakalkökü on 18.02.2021.
//

import  UIKit

class MovieDetailsViewController:UIViewController {
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var headerLabel: UILabel!
    var movie:Movie? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overviewTextView.isEditable = false
        if let movie = movie {
            self.headerLabel.text = movie.title
            self.moviePosterImageView.image = movie.image
            self.overviewTextView.text = "\(movie.overview ?? "") \n\nTotal Vote Count: \(movie.voteCount ?? 0)  \nVote Average:\(movie.voteAverage ?? 0)"
        }
   
        
    }
}
