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
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    let userDefaults = UserDefaultsManager.instance
    var movie:Movie?
     
    func fillMovieInformation(_ movie: Movie) {
        
        //Fills all the movie information.
        
        self.headerLabel.text = movie.title
        self.moviePosterImageView.image = movie.image
        self.overviewTextView.text = "\(movie.overview ?? "") \n\nTotal Vote Count: \(movie.voteCount ?? 0)  \nVote Average:\(movie.voteAverage ?? 0)"
        changeFavoriteStatusOfMovie(fill: movie.favorite)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overviewTextView.isEditable = false
        if let movie = movie {
            fillMovieInformation(movie)
        }
   
        
    }
    @IBAction func changeFavoriteStatus(_ sender: Any) {
        guard let movie = movie else {
            return
        }
        
        
        movie.favorite = !movie.favorite
        // according to favorite status of movie, movie is added to or removed from UserDefaults via UserDefaultsManager.
        movie.favorite ?
        userDefaults.addMovieToFavorites(movie.id) : userDefaults.removeFromFavorites(movie.id)
        changeFavoriteStatusOfMovie(fill: movie.favorite)
    }
    
    func changeFavoriteStatusOfMovie(fill:Bool) {
        //Changes the image of the favoriteButton according to favorite statsu of movie.
            if(fill){
                self.favoriteButton.image = UIImage(systemName: "star.fill")
            }else {
                self.favoriteButton.image = UIImage(systemName: "star")
            }
        
      
    }
}
