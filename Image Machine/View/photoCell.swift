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
        
        self.imageView.image = data
    }
}
