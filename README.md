# MovieLand

MovieLand is an iOS Application that gives the oppurtunity to see list of popular movies on TMdb, the details of each of them and add them to favorites.

## Preview

![MovieLand Preview](Demo/demo.gif)

## Details

MovieLand consists of two screens. One screen contains the list of the movies, and the other one shows the details of the movie. The detail page contains 
Movie Poster, Name, Description, Vote Count, and a star button. Because of TMdb API returning all these informations in 'popular movies' request, there is no need
to send additional requests to fetch 'movie details'.

**FetchingManager** is a helper class that provides developer to manage all fetching processes in one block.
Below the function 'fetchMovies' can be seen. If the response of the request failed when casting to ```[String:Any]```, a hardcoded error takes place
in completion. If the casting prevails movieList would be filled.

```swift
func fetchMovies(_ completion:@escaping FetchingResponse,_ page:Int =  1) {
   guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?language=en-US&api_key=\(API_KEY)&page=\(page)") else {            
   return
   }
   var request = URLRequest(url: url)
   request.httpMethod = "GET"
        
   let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
   if let data = data {
         do {
               guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                   completion(false,"Unknown error has occured")
                   return
              }
               if let failureMessage = json["status_message"] {
                   completion(false,failureMessage as! String)
               }else {
                   self.fillMovieList(json)
                   completion(true,"")
                    }
                  
           }catch {
               completion(false,"Unknown error has occured")
           }
       }
            
   }
   task.resume()
   }
  ```
After movieList is filled, movies in the list are can be seen in a CollectionView. The posters of the movies were downloaded with the 'fetchPoster' function in the FetchingManager.
```swift
func fetchPoster(_ posterPath:String?,_ completion:@escaping ImageResponse,withSize size:Int = 200) {
        
        //Function fetches poster with desired width. Default value is 200.
        
        guard let posterPath = posterPath else {
            //posterPath doesnt found so no need to continue to download process
            return
        }
        let posterUrl =  URL(string: "https://image.tmdb.org/t/p/w\(size)\(posterPath)")!
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: posterUrl) { (data, response, error) in
            // The download has finished.
            if error != nil {
                completion
            } else {
                // No errors found.
                if (response as? HTTPURLResponse) != nil {
                    if let imageData = data {
                        //Image was downloaded.
                        let image = UIImage(data: imageData)
                        completion(image)
                        
                    } else {
                        //Image can not be downloaded. So placeholder image will be seen.
                        completion(nil)                    }
                } else {
                    //Image can not be downloaded. So placeholder image will be seen.
                    completion(nil)
                }
            }
        }
        downloadPicTask.resume()
    } 
```
Only the posters of movies that can be seen on the screen are downloading. So that better memory performance can be expected. Also, if the image of the movie has been downloaded before, there is no need to download it again!
The below code works that way!

````swift
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
````

After selecting the desired movie, the app navigates to the MovieDetails page. There is an opportunity to add it to favorites or remove it from them via the UserDefaultsManager Favorite movies are stored in the phone memory as a Dictionary.
If it is stored as an array, there needs to be a nested loop, which will give a bad performance for an enormous number of inputs. Dictionaries can work better on lookups.
The below code makes it happen!

```swift
 func addMovieToFavorites(_ id:Int) {
        //adds movie to favorites map.
        var favorites = defaults.dictionary(forKey: "movie_land_favorites") ?? [:]
        favorites["\(id)"] = true
        defaults.set(favorites, forKey: "movie_land_favorites")
    }
    
    func removeFromFavorites(_ id:Int) {
        //Removes the movie which has the given id from favorites
        var favorites = defaults.dictionary(forKey: "movie_land_favorites") ?? [:]
        favorites["\(id)"] = false
        defaults.set(favorites, forKey: "movie_land_favorites")
    }
    
    func isMovieAmongFavorites(_ id:Int) -> Bool {
        //checks if the movie among favorites.
        let favorites = defaults.dictionary(forKey: "movie_land_favorites") ?? [:]
        guard let val = favorites["\(id)"]  as? Bool else {
            
            return false
        }
        
        return val
        
    }

```

## Authors
* Cagri Portakalkoku 


