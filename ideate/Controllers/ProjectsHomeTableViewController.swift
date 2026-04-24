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
        print("TEST: user is nil? \(user == nil)")
        //navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        if let user = user,
           let projectlist = user.projectlist,
           let projects = projectlist.projects {

            let projectsArray = (projects.allObjects as! [Project]).sorted {
                $0.name ?? "" < $1.name ?? ""
            }

            let project = projectsArray[indexPath.row]
            cell.projectNameLabel.text = project.name
        }
        return cell
    }
    
    func addItemDidAdd(name: String) {
        if let user = user {
            let projectlist: ProjectList
                if let existing = user.projectlist {
                    projectlist = existing
                } else {
                    let newList = ProjectList(context: context)
                    user.projectlist = newList
                    newList.user = user
                    projectlist = newList
                    print("created new projectlist")
                }
            let project = Project(context: context)
            project.name = name
            projectlist.addToProjects(project)
            do {
                try context.save()
                context.refresh(user, mergeChanges: true)
                print("user saved")
                print(projectlist.projects?.count)
            } catch {
                print("error: \(error)")
            }
        }
        tableView.reloadData() //reload view
    }
}
