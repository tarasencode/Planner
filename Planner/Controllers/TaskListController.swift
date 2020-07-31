//
//  TaskListController.swift
//  Planner
//
//  Created by oleG on 25/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import UIKit

class TaskListController: UITableViewController {
    
    let taskDao = TaskDaoImp.current
    
    var newTask: Task?
    
    var searchController: UISearchController!
    
    let numberOfSections = 2
    let quickTaskSection = 0
    let taskListSection = 1
    
    var shouldHideQuickTask = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case quickTaskSection:
            return 1
        case taskListSection:
            return taskDao.items.count
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == quickTaskSection,
                    let cell = tableView.dequeueReusableCell(withIdentifier: "quickTaskCell", for: indexPath) as? QuickTaskCell {
            cell.delegate = self
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskListCell else {
            fatalError("There should be TaskListCell")
        }
        cell.delegate = self
        
        let task = taskDao.items[indexPath.row]
        
        cell.taskNameLabel.text = task.name
        cell.taskCategoryLabel.text = (task.category?.name ?? "")
        cell.checkmarkButton.isSelected = task.completed
        
        if let priority = task.priority {
            var priorityColor: UIColor?
            
            switch priority.index {
            case 0:
                priorityColor = UIColor(named: "lowPriority")
            case 1:
                priorityColor = UIColor(named: "midPriority")
            case 2:
                priorityColor = UIColor(named: "hiPriority")
            default:
                priorityColor = UIColor.white
            }
            cell.taskPriorityLabel.backgroundColor = priorityColor
        }
        
        if let deadline = task.deadline {
            let daysLeft = deadline.getOffset(from: Date().today)
            var daysLeftString = ""
            
            switch daysLeft {
            case 0:
                daysLeftString = "Today"
            case 1:
                daysLeftString = "Tomorrow"
            case -1:
                daysLeftString = "\(daysLeft) day"
                cell.taskDeadlineLabel.textColor = .red
            case ..<0:
                daysLeftString = "\(daysLeft) days"
                cell.taskDeadlineLabel.textColor = .red
            default:
                daysLeftString = "\(daysLeft) days"
            }
            cell.taskDeadlineLabel.text = daysLeftString
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == quickTaskSection {
            return shouldHideQuickTask ? 0 : 44
        } else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == taskListSection ? true : false
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            taskDao.delete(taskDao.items[indexPath.row])
            taskDao.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDetails":
            guard let tdc = segue.destination as? TaskDetailsController else {
                fatalError("segue error")
            }
            
            let index = tableView.indexPathForSelectedRow!.row
            tdc.task = taskDao.items[index]
            
            tdc.navigationItem.title = "Task details"
        case "newTask":
            guard let nc = segue.destination as? UINavigationController,
                let tdc = nc.viewControllers.first as? TaskDetailsController else {
                fatalError("segue error")
            }
            
            newTask = Task(context: taskDao.context)
            newTask?.name = "New task"
            tdc.task = newTask
            
            tdc.isNewTask = true
            tdc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
            tdc.navigationItem.title = "New Task"
        default:
            return
        }
    }
    
    // MARK: unwind
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
        if let newTask = newTask {
            taskDao.delete(newTask)
        }
        newTask = nil
    }
    
    @IBAction func unwindToTaskListAndSave(segue: UIStoryboardSegue) { //FIXME: better name
        switch segue.identifier {
        case "deleteTask":
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            
            taskDao.delete(taskDao.items[indexPath.row])
            taskDao.items.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        case "saveTask":
            if let indexPath = tableView.indexPathForSelectedRow {
                taskDao.save()
                
                tableView.reloadRows(at: [indexPath], with: .fade)
            } else {
                taskDao.addOrUpdate(newTask!)
                
                let indexPath = IndexPath(row: taskDao.items.count-1, section: taskListSection)
                tableView.insertRows(at: [indexPath], with: .top)
                
            }
        default:
            return
        }

    }
}
// MARK: CellDelegate
extension TaskListController: TaskListCellDelegate, QuickTaskCellDelegate {
    func enterButtonTapped(taskName: String) {
        newTask = Task(context: taskDao.context)
        newTask?.name = taskName
        taskDao.addOrUpdate(newTask!)
        
        let indexPath = IndexPath(row: taskDao.items.count-1, section: taskListSection)
        tableView.insertRows(at: [indexPath], with: .top)
        
    }
    
    func checkButtonTapped(sender: TaskListCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            taskDao.items[indexPath.row].completed.toggle()
            taskDao.save()
        }
    }
}

// MARK: UISearchBarDelegate
extension TaskListController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        shouldHideQuickTask = searchController.searchBar.text != "" ? true : false
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces),
                text.count > 0  else {return}
            _ = taskDao.search(text: text)
            tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        _ = taskDao.getAll()
        shouldHideQuickTask = false
        tableView.reloadData()
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchBar.placeholder = "Enter task name"
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.showsScopeBar = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

    }
}
