//
//  Extensions.swift
//  LetsChitChat
//
//  Created by Pritam Hinger on 09/07/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

//import Foundation
import UIKit

let imageCahce = NSCache<AnyObject, AnyObject>()

extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UIImageView{
    func loadImageFromCache(withUrl urlString:String) {
        self.image = nil
        if let cachedImage = imageCahce.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if error != nil{
                print(error!)
            }
            else{
                print("setting image")
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!){
                        imageCahce.setObject(downloadedImage, forKey: urlString as AnyObject)
                        self.image = downloadedImage
                    }
                }
            }
        }).resume()
    }
}
