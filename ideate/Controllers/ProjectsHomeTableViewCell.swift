//
//  ProjectsHomeTableViewCell.swift
//  ideate
//
//  Created by Hannah Chung on 4/18/26.
//

import UIKit
import CoreData

class ProjectsHomeTableViewCell: UITableViewCell {

    let context = persistentContainer.viewContext

    @IBOutlet weak var projectNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
