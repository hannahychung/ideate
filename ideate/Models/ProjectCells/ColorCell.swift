//
//  ColorCell.swift
//  ideate
//
//  Created by Hannah Chung on 4/6/26.
//

import UIKit

protocol ColorCellDelegate: AnyObject {
    func colorCell(_ cell: ColorCell, didChange color: UIColor)
}

class ColorCell: UICollectionViewCell {
    
    @IBOutlet weak var colorwell: UIColorWell!
    @IBOutlet weak var colorView: UIView!
    
    weak var delegate: ColorCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorwell.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
    }
    
    @objc func colorChanged() {
        guard let color = colorwell.selectedColor else { return }
            colorView.backgroundColor = color
            delegate?.colorCell(self, didChange: color)
    }
    
    func configure(colorHex: String) {
        colorView.backgroundColor = UIColor(hex: colorHex)
        colorwell.selectedColor = UIColor(hex: colorHex)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB
            (r, g, b, a) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF, 255)
        default:
            (r, g, b, a) = (255, 255, 255, 255)
        }

        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}
