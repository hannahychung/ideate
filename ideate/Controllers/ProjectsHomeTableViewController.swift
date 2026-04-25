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
    var user: IdeateUser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = SessionUser.shared.currentUser
        navigationItem.leftBarButtonItem = editButtonItem
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
            } catch {
                print("error: \(error)")
            }
        }
        tableView.reloadData() //reload view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func returnSortedArray(list: ProjectList) -> [Project]{
        let projectsArray = (list.projects!.allObjects as! [Project]).sorted {
            $0.name ?? "" < $1.name ?? ""
        }
        return projectsArray
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
           let projectlist = user.projectlist{
            
            let projectsArray = returnSortedArray(list: projectlist)
            
            let project = projectsArray[indexPath.row]
            cell.projectNameLabel.text = project.name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if let user = user,
           let projectlist = user.projectlist{
            
            let projectsArray = returnSortedArray(list: projectlist)
            
            let projectToDelete = projectsArray[indexPath.row]
            projectlist.removeFromProjects(projectToDelete)
            context.delete(projectToDelete)
            do {
                try context.save()
            } catch {
                print("error deleting project: \(error)")
            }
            
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let popup = UIAlertController(title: "Make a new project", message: "Make a new project", preferredStyle: .alert)
        popup.addTextField { textField in textField.placeholder = "Project name"}
        popup.addAction(UIAlertAction(title: "submit", style: .default) { _ in
            if let text = popup.textFields?.first?.text {
                self.addItemDidAdd(name: text)}
        })
        present(popup, animated: true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !tableView.isEditing
    }
    
    // MARK: Presenting individual projects
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toProjectSegue", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProjectSegue" {
            guard
                let targetVC = segue.destination as? ProjectViewController,
                let indexPath = sender as? IndexPath,
                let user = user,
                let projectlist = user.projectlist
            else { return }
            let projectsArray = returnSortedArray(list: projectlist)
            let projectSelected = projectsArray[indexPath.row]
            targetVC.project = projectSelected
            print("project selected: \(projectSelected.name ?? "no project")")
        }
    }
}
