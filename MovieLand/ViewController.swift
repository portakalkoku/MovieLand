//
//  ViewController.swift
//  MovieLand
//
//  Created by Çağrı Portakalkökü on 17.02.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var movieCollectionView: UICollectionView!
    let itemsPerRow:CGFloat = 2
	
	var nameList:[String] = ["The Lord Of the Rings: The Two Towers","cagri","kursat","nurdan","merve","cagri","kursat","nurdan","merve","cagri","kursat","nurdan","merve","cagri","kursat","nurdan","merve","cagri","kursat","nurdan","merve","cagri","kursat","nurdan","merve","cagri","kursat","nurdan","merve","cagri","kursat","nurdan","merve","cagri","kursat","nurdan"]

    
    
    
	override func viewDidLoad() {
        super.viewDidLoad()
		let nibCell = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
		movieCollectionView.register(nibCell, forCellWithReuseIdentifier: "MovieCollectionViewCell")
		FetchingManager.instance.fetchMovies { (movieNameList, success,errorMessage) in
			if(!success) {
				CustomAlertDialog.instance.showAlertDialog(self, message: errorMessage)
	
			}else {
				self.nameList = movieNameList
			}
		}
		

        
    }


}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {


	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)
    -> CGSize {
      let cellMargin:CGFloat = 10
        let availableWidth =  UIScreen.main.bounds.width - ((itemsPerRow + 1) * cellMargin)
           let widthPerItem = availableWidth / itemsPerRow
           
        return CGSize(width: widthPerItem, height: 2 * widthPerItem)

    }
	
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let movieName = nameList[indexPath.row]
        cell.titleLabel.text = movieName
        cell.imageView.image = UIImage(named:"placeholder")

        return cell    }
    
    
    

}


