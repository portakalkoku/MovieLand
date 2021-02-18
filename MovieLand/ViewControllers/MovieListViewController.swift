//
//  ViewController.swift
//  MovieLand
//
//  Created by Çağrı Portakalkökü on 17.02.2021.
//

import UIKit

class MovieListViewController: UIViewController {
    @IBOutlet weak var movieCollectionView: UICollectionView!
    let itemsPerRow:CGFloat = 2
	var movieSource:[Movie] = []
	var selectedMovie:Movie?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		let nibCell = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
		movieCollectionView.register(nibCell, forCellWithReuseIdentifier: "MovieCollectionViewCell")
		FetchingManager.instance.fetchMovies { (movieNameList, success,errorMessage) in
			if(!success) {
				CustomAlertDialog.instance.showAlertDialog(self, message: errorMessage)
			}else {
				self.movieSource = movieNameList
			}
		}
		

        
    }

	override func viewDidAppear(_ animated: Bool) {
		movieCollectionView.reloadData()
	}

}

extension MovieListViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {


	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)
    -> CGSize {
      let cellMargin:CGFloat = 10
        let availableWidth =  UIScreen.main.bounds.width - ((itemsPerRow + 1) * cellMargin)
           let widthPerItem = availableWidth / itemsPerRow
           
        return CGSize(width: widthPerItem, height: 2 * widthPerItem)

    }
	
	
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieSource.count
    }
    	
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
		let movieName = movieSource[indexPath.row].title
        cell.titleLabel.text = movieName
		if let image = movieSource[indexPath.row].image {
			print("doesnt need download again")
			setCellImage(cell: cell, image: image)
		}else {
		FetchingManager.instance.fetchPoster(movieSource[indexPath.row].posterPath) { (image) in
			guard let image = image else {
				return
			}
			self.movieSource[indexPath.row].setImage(image: image)
			self.setCellImage(cell: cell, image: image)
		}
		}

        return cell    }
    
    
	func setCellImage(cell:MovieCollectionViewCell,image:UIImage) {
		DispatchQueue.main.async {
			cell.imageView.image = image
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedMovie = self.movieSource[indexPath.row]
		self.performSegue(withIdentifier: "showMovieDetails", sender: self)
	}
	
	
	//navigation codes
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if(segue.identifier == "showMovieDetails") {
			if let destViewController = segue.destination as? MovieDetailsViewController {
				destViewController.movie  = selectedMovie
			}
			
		}
		
	}

}


