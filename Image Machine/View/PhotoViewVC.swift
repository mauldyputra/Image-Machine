//
//  PhotoViewVC.swift
//  Image Machine
//
//  Created by Mauldy Putra on 25/07/21.
//

import UIKit

class PhotoViewVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Machine Photo \(index ?? 1)"
        self.imageView.image = image
    }
}
