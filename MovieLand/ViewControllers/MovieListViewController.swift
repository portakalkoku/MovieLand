//
//  ViewController.swift
//  MovieLand
//
//  Created by Çağrı Portakalkökü on 17.02.2021.
//

import UIKit

class MovieListViewController: UIViewController,UISearchBarDelegate {
    @IBOutlet weak var movieCollectionView: UICollectionView!
    let itemsPerRow:CGFloat = 2
	var movieSource:[Movie] = []
	var selectedMovie:Movie?
	var page = 1
	let fetching = FetchingManager.instance
	var searchText = ""
		
	override func viewDidLoad() {
        super.viewDidLoad()
		nibRegistrar("LoadMoreCell")
		nibRegistrar("MovieCollectionViewCell")
		fetchMovies()
		
        
    }
	
	func nibRegistrar(_ nibName:String) {
		//CollectionView cells designed as xib file. So they need to ne registered to collectionview.
		let cell = UINib(nibName: nibName, bundle: nil)
		movieCollectionView.register(cell, forCellWithReuseIdentifier: nibName)
	}
	
	 func filterShownMovies() {
		//filters fetched movies in realtime. In FetchingManager movielist has to be filled first.
		
		if(searchText != "") {
			movieSource = fetching.movieList.filter { (m:Movie) -> Bool in
				m.title!.lowercased().contains(searchText.lowercased())
			}
		}else {
			//if search text equals empty string moviesource assigned as all fetched movies.
			movieSource = fetching.movieList
		}
		self.reloadCollectionView()
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		self.searchText = searchText
		filterShownMovies()
	
	}
	

	override func viewDidAppear(_ animated: Bool) {
		reloadCollectionView()	}
	
	func reloadCollectionView() {
		DispatchQueue.main.async {
			self.movieCollectionView.reloadData()

		}
	}

}

extension MovieListViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {


	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)
    -> CGSize {
		let cellMargin:CGFloat = 10
        let availableWidth =  UIScreen.main.bounds.width - ((itemsPerRow + 1) * cellMargin)
           let widthPerItem = availableWidth / itemsPerRow
		
		//Normally it is desired to have 2 columns in collectionview. Below function calculates the available width for a cell. Padding values are taken into account.
		//Because of Load more button always be added to bottom of the collectionview, the last item gets all the availablewidth.
		return indexPath.row != movieSource.count ? CGSize(width: widthPerItem, height: 2 * widthPerItem) : CGSize(width:availableWidth,height: 32)

    }

	
	
	
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		//Load more added to bottom of the collectionview.
        return movieSource.count + 1
    }
	
	  func getMovieCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
		
		
		//function returns the moviecell after labeling the title and starting to download image if necessary.
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
		let movieAtCell:Movie = movieSource[indexPath.row]
		cell.titleLabel.text = movieAtCell.title
		movieAtCell.favorite = UserDefaultsManager.instance.isMovieAmongFavorites(movieSource[indexPath.row].id)
		cell.favoriteStar.image =  UIImage(systemName: movieAtCell.favorite ? "star.fill" : "star")
		if let image = movieAtCell.image {
			
			//If image is downloaded before, there is no need to download the same image again.
			setCellImage(cell: cell, image: image)
		}else {
			
			//If image is not downloaded before, the image has to be downloaded again.
			
			fetching.fetchPoster(movieSource[indexPath.row].posterPath) { (image) in
				guard let image = image else {
					return
				}
				movieAtCell.setImage(image: image)
				self.setCellImage(cell: cell, image: image)
			}
		}
		
		return cell
	}
	
	 func getLoadMoreCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
		//returns the loadmore cell.
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadMoreCell", for: indexPath) as! LoadMoreCell
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		//Last item of the collectionview returns as loadmorecell.
		if indexPath.row == movieSource.count {
			return getLoadMoreCell(collectionView, indexPath)
		}else {
			return getMovieCell(collectionView, indexPath)
			
		} }

    
    
	func setCellImage(cell:MovieCollectionViewCell,image:UIImage) {
		//Sets image
		DispatchQueue.main.async {
			cell.imageView.image = image
		}
		
	}
	
	fileprivate func fetchMovies() {
		//sends the fetch command to FetchingManager. Before sending the command, loader is shown, after the response loader is hidden.
		
		let spinner = PopupViews.instance.showLoader(on: self.view)
		fetching.fetchMovies({  (success,errorMessage) in
								spinner.hideLoader()
								if(!success) {
									PopupViews.instance.showAlertDialog(self, message: errorMessage)
								}else {
									//after each fetch movie command, the page number increases.
									self.page+=1
									self.filterShownMovies()
								}},self.page)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if(indexPath.row != self.movieSource.count) {
		selectedMovie = self.movieSource[indexPath.row]
		self.performSegue(withIdentifier: "showMovieDetails", sender: self)
		}else {
			//Because last item is LoadMoreCell.
			fetchMovies()
		}
	}
	
	
	//navigation codes
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	
		if(segue.identifier == "showMovieDetails") {
			if let destViewController = segue.destination as? MovieDetailsViewController {
				//sets the movie variable in MovieDetailsViewController as selectedMovie.
				destViewController.movie  = selectedMovie
			}
			
		}
		
	}

}


