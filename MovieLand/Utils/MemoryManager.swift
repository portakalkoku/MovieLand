//
//  MemoryManager.swift
//  MovieLand
//
//  Created by Çağrı Portakalkökü on 18.02.2021.
//

class MemoryManager{
    //After so many pages has been loaded. The imagedata start to fill memory.
    //In order to prevent that the images of the page number = currentpage - 2 will be deleted.
    public static let  instance = MemoryManager()
    
    func deleteImages(_ page:Int) {
        
        let limit = (page -  1) * 20
        for movieIndex in limit - 20 ... limit {
            FetchingManager.instance.movieList[movieIndex].image = nil
            
        }
        
    }
}
