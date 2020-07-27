//
//  TaskListController.swift
//  Planner
//
//  Created by oleG on 25/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import UIKit

class TaskListController: UITableViewController {
    
    let db = DataBase()
    
    private var taskList: [Task]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//db.initTestData()
        
        taskList = db.getAllTasks()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskListCell else {
            fatalError("There should be TaskListCell")
        }
        let task = taskList[indexPath.row]
        
        cell.taskNameLabel.text = task.name
        cell.taskCategoryLabel.text = (task.category?.name ?? "")
        
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
            let daysLeftString: String
            
            switch daysLeft {
            case 0:
                daysLeftString = "Today"
            case 1:
                daysLeftString = "Tomorrow"
            case ..<0:
                daysLeftString = "\(daysLeft) d."
                cell.taskDeadlineLabel.textColor = .red
            default:
                daysLeftString = "\(daysLeft) d."
            }
            cell.taskDeadlineLabel.text = daysLeftString
        }
        
        if let info = task.info, info.count > 0 {
            cell.taskInfoButton.isHidden = false
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            db.deleteTask(taskList[indexPath.row])
            taskList.remove(at: indexPath.row)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
