//
//  TextCell.swift
//  ideate
//
//  Created by Hannah Chung on 4/6/26.
//

import UIKit

class TextCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    func configure(text: String) {
        label.text = text
    }
}
