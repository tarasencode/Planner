//
//  OptionsController.swift
//  Planner
//
//  Created by oleG on 30/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import UIKit
import CoreData

class OptionsController: UITableViewController {
    
    let categoryDao = CategoryDaoImp.current
    let priorityDao = PriorityDaoImp.current
    
    var option: OptionType = .category
    var task: Task?
    var selectedIndexPath: IndexPath?
    
    var categories: [Category] = []
    var priorities: [Priority] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categories = categoryDao.getAll()
        priorities = priorityDao.getAll()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return option == .category ? categories.count : priorities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        switch option {
        case .category:
            cell.textLabel?.text = categories[indexPath.row].name
            cell.accessoryType = categories[indexPath.row] == task?.category ? .checkmark : .none
        case .priority:
            cell.textLabel?.text = priorities[indexPath.row].name
            cell.accessoryType = priorities[indexPath.row] == task?.priority ? .checkmark : .none
        }
        
        if cell.accessoryType == .checkmark,
                selectedIndexPath == nil {
            selectedIndexPath = indexPath
        }
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch option {
        case .category:
            task?.category = categories[indexPath.row]
        case .priority:
            task?.priority = priorities[indexPath.row]
        }
        
        if let previous = selectedIndexPath {
            tableView.cellForRow(at: previous)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedIndexPath = indexPath
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
}
