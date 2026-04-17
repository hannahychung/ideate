//
//  ColorCell.swift
//  ideate
//
//  Created by Hannah Chung on 4/6/26.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    @IBOutlet weak var colorwell: UIColorWell!
    @IBOutlet weak var colorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorwell.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
    }
    
    @objc func colorChanged() {
        colorView.backgroundColor = colorwell.selectedColor
    }
    
    func configure(color: UIColor) {
        colorView.backgroundColor = color
        colorwell.selectedColor = color
    }
}
