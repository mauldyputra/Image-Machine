//
//  photoCell.swift
//  Image Machine
//
//  Created by Mauldy Putra on 22/07/21.
//

import UIKit

class photoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var data: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageView.image = UIImage(named: "machine")
//        setImage(image: data)
    }
    
    private func setImage(image: UIImage?) {
        self.imageView.image = image
        if let image = image, image.size.width != 0 {
            self.imageView.isHidden = false
        } else {
            self.imageView.isHidden = true
        }
    }

}
