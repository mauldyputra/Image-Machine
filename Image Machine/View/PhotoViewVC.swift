//
//  PhotoViewVC.swift
//  Image Machine
//
//  Created by Mauldy Putra on 25/07/21.
//

import UIKit

class PhotoViewVC: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
}
