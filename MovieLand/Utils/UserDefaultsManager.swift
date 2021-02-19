//
//  SavingManager.swift
//  MovieLand
//
//  Created by Çağrı Portakalkökü on 18.02.2021.
//

import Foundation


class UserDefaultsManager {
    let defaults = UserDefaults.standard
    
    public static let instance = UserDefaultsManager()
    //For getting rid of the for loop, a dictionary is chosen as a storage structure.
    //O(1) is better. Because dictionaries is constant time while looking up.
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
    
}
