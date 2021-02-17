//
//  CustomAlertDialog.swift
//  MovieLand
//
//  Created by Çağrı Portakalkökü on 17.02.2021.
//

import Foundation
import UIKit
class CustomAlertDialog {
    public static let instance = CustomAlertDialog()
    func showAlertDialog(_ on:ViewController,message:String){
        //shows simple alert dialog with given message. It works on the main thread
        DispatchQueue.main.async {
            let alert = UIAlertController(title:"Warning",message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            on.present(alert, animated: true)
        }
    }
}
