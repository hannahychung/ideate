//
//  ProjectsHomeTableViewController.swift
//  ideate
//
//  Created by Hannah Chung on 4/18/26.
//

import UIKit
import CoreData

class ProjectsHomeTableViewController: UITableViewController {

    let context = persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }

}

