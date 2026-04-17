//
//  ImageCell.swift
//  ideate
//
//  Created by Hannah Chung on 4/6/26.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(url: String) {
        if let imageURL = URL(string: url) {
            // simplest version (not ideal but works)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: data) {
                    
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
}
