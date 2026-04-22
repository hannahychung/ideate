//
//  ProjectsHomeTableViewController.swift
//  ideate
//
//  Created by Hannah Chung on 4/18/26.
//

import UIKit
import CoreData

class ProjectsHomeTableViewController: UITableViewController {

    var user: IdeateUser? = nil
    let context = persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addItemDidAdd(name: "testing")
        addItemDidAdd(name: "testing 2")
        //navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let user = user, let projectlist = user.projectlist, let projects = projectlist.projects{
            return projects.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectsHomeTableViewCell
        if let user = user, let projectlist = user.projectlist, let projects = projectlist.projects {
            let project = projects.allObjects[indexPath.row] as! Project
            cell.projectNameLabel.text = project.name
        }
        return cell
    }
    
    func addItemDidAdd(name: String) {
        var rowInx = 0
        if let user = user, let projectlist = user.projectlist, let projects = projectlist.projects{
            rowInx = projects.count
            let project = Project(context: context)
            project.name = name
            do {
                try context.save()
                print("user saved")
            } catch {
                print("error: \(error)")
            }
        }
        let indexPath = IndexPath(row: rowInx, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic) //insert into view
    }
}

