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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskDao.items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            guard let dvc = segue.destination as? TaskDetailsController else {
                fatalError("segue error")
            }
            
            let index = tableView.indexPathForSelectedRow!.row
            dvc.task = taskDao.items[index]
            
            dvc.navigationItem.title = "Task details"
        case "newTask":
            guard let nc = segue.destination as? UINavigationController,
                let dvc = nc.viewControllers.first as? TaskDetailsController else {
                fatalError("segue error")
            }
            dvc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
            dvc.navigationItem.title = "New Task"
        default:
            return
        }
    }
    
    // MARK: unwind
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToTaskListAndSave(segue: UIStoryboardSegue) { //FIXME: better name
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        switch segue.identifier {
        case "deleteTask":
            taskDao.delete(taskDao.items[indexPath.row])
            taskDao.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        case "saveTask":
            taskDao.save()
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            return
        }

    }
}

extension TaskListController: TaskListCellDelegate {
    func checkButtonTapped(sender: TaskListCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            taskDao.items[indexPath.row].completed.toggle()
            taskDao.save()
        }
    }
}
