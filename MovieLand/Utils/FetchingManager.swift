//
//  NetworkManager.swift
//  MovieLand
//
//  Created by Çağrı Portakalkökü on 17.02.2021.
//

import Foundation
import UIKit

typealias FetchingResponse = ([Movie],Bool,String) -> Void
typealias ImageResponse = (UIImage?) -> Void
class FetchingManager {
    
   public static let instance:FetchingManager = FetchingManager()
   let API_KEY = "fd2b04342048fa2d5f728561866ad52a"
    let unknownErrorStr = "Unknown error has occured"
    
    
    //page will be added
    func fetchMovies(_ completion:@escaping FetchingResponse) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?language=en-US&api_key=\(API_KEY)&page=1") else {
            //Buraya kendi exceptionımız yazılabilir.
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                //refactor it. it might be useful for all requessts
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                        completion([],false,"Unknown error has occured")
                        return
                    }
                    if let failureMessage = json["status_message"] {
                        completion([],false,failureMessage as! String)
                    }else {
                        completion(self.fillMovieList(json),true,"")
                    }
                
                }catch {
                    completion([],false,"Unknown error has occured")
                }
            }
        
        }
        task.resume()
    }
    
    func fetchPoster(_ posterPath:String?,_ completion:@escaping ImageResponse,withSize size:Int = 200) {
        guard let posterPath = posterPath else {
            //posterPath doesnt found so no need to continue to download process
            return
        }
        print(posterPath)
        let catPictureURL =  URL(string: "https://image.tmdb.org/t/p/w\(size)\(posterPath)")!
print(catPictureURL)        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)

        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                       completion(image)
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }

        downloadPicTask.resume()
        
        
    }
    
    

    func fillMovieList(_ source:[String:Any]) -> [Movie] {
        var movieList:[Movie] = []
        
        if let results = source["results"] as? [[String:Any]] {
                for movieDict in results {
                    movieList.append(Movie(from: movieDict))
                }
            
        }
        return movieList
    
    }
    
}
