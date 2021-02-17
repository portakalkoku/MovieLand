//
//  NetworkManager.swift
//  MovieLand
//
//  Created by Çağrı Portakalkökü on 17.02.2021.
//

import Foundation

typealias FetchingResponse = ([String],Bool,String) -> Void
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
                        completion(self.fillMovieList(),true,"")
                    }
                
                }catch {
                    completion([],false,"Unknown error has occured")
                }
            }
        
        }
        task.resume()
    }
    

    func fillMovieList() -> [String] {
        var movieList:[String] = []
        for n in 1...50 {
            movieList.append(String.init(n))
        }
        return movieList
    }
    
}
