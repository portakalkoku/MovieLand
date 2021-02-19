//
//  CustomAlertDialog.swift
//  MovieLand
//
//  Created by Çağrı Portakalkökü on 17.02.2021.
//

import Foundation
import UIKit
class PopupViews {
    //The views which informs user about processes. for example: AlertDialog or ActivityIndicator.
    
    public static let instance = PopupViews()
    func showAlertDialog(_ on:MovieListViewController,message:String){
        //shows simple alert dialog with given message. It works on the main thread
        DispatchQueue.main.async {
            let alert = UIAlertController(title:"Warning",message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            on.present(alert, animated: true)
        }
    }
    func showLoader(on: UIView) -> UIActivityIndicatorView{
        
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height:60))
        spinner.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        spinner.layer.cornerRadius = 3.0
        spinner.clipsToBounds = true
        spinner.hidesWhenStopped = true
        spinner.color = .white
        spinner.center = on.center
        on.addSubview(spinner)
        spinner.startAnimating()
        return spinner }
    
    
}
extension UIActivityIndicatorView {
    func hideLoader() {
        DispatchQueue.main.async {
            self.stopAnimating()
        }
    }
}

