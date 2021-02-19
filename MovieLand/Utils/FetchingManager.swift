//
//  NetworkManager.swift
//  MovieLand
//
//  Created by Çağrı Portakalkökü on 17.02.2021.
//

import Foundation
import UIKit

typealias FetchingResponse = (Bool,String) -> Void
typealias ImageResponse = (UIImage?) -> Void
class FetchingManager {
    
    public static let instance:FetchingManager = FetchingManager()
    let API_KEY = "fd2b04342048fa2d5f728561866ad52a"
    let unknownErrorStr = "Unknown error has occured"
    
    
    func fetchMovies(_ completion:@escaping FetchingResponse,_ page:Int =  1) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?language=en-US&api_key=\(API_KEY)&page=\(page)") else {            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                //refactor it. it might be useful for all requessts
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
            if let e = error {
                print("Error downloading cat picture: \(e)")
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
    
    var movieList:[Movie] = []
    
    
    /* For pagination, nested loops can be a solution.
     However it has quadratic time complexity. So, hashmap structure was used.
     Because hashmaps are O(1) which means linear time */
    var addedMovies:[Int:Bool] = [:]
    func fillMovieList(_ source:[String:Any])  {
    //addedMovies dictionary is used for the get if the movie is added the movieList before
        if let results = source["results"] as? [[String:Any]] {
            for movieDict in results {
                let movie:Movie = Movie(from: movieDict)
                if  addedMovies[movie.id] == nil  {
                    self.movieList.append(Movie(from: movieDict))
                    addedMovies[movie.id] = true
                    
                }
            }
            
        }
        
        
    }
    
}
