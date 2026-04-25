//
//  SurveyTableViewCell.swift
//  ideate
//
//  Created by Hannah Chung on 4/25/26.
//

import UIKit

class SurveyTableViewCell: UITableViewCell {

    @IBOutlet weak var surveyLabel: UILabel!
    
    @IBOutlet weak var surveyIcon: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
