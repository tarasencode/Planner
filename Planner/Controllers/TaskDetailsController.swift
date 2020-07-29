//
//  TaskDetailController.swift
//  Planner
//
//  Created by oleG on 27/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import UIKit

class TaskDetailsController: UITableViewController {
    
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var taskCategoryLabel: UILabel!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskDeadlineField: UITextField!
    @IBOutlet weak var taskInfoView: UITextView!
    @IBOutlet weak var deadlineDatePicker: UIDatePicker!
    
    var task:Task?
    var isPickerHidden = true
    var firstShow = true

    @IBAction func enterButtonTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func nameEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDeadlineField(date: sender.date)
    }
    
    @IBAction func deadlineTapped(_ sender: Any) {
        self.view.endEditing(true)
        isPickerHidden = !isPickerHidden
        taskDeadlineField.textColor = isPickerHidden ? .black : tableView.tintColor
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deadlineDatePicker.date = Date().shiftDay(by: 1)
        
        if let task = task {
            taskNameField.text = task.name
            taskCategoryLabel.text = task.category?.name
            taskPriorityLabel.text = task.priority?.name
            taskInfoView.text = task.info
            
            if let deadline = task.deadline {
                taskDeadlineField.text = Date.dateFormatter.string(from: deadline)
                deadlineDatePicker.date = deadline
            }
        }
        
        updateSaveButtonState()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    func updateSaveButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = taskNameField.hasText
    }
    
    func updateDeadlineField(date: Date) {
        taskDeadlineField.text = Date.dateFormatter.string(from: date)
    }
    
    // MARK: Cell height
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let largeCellHeight: CGFloat = 200
        let infoCellHeight: CGFloat = 66
        let normalCellHeight: CGFloat = 44
        
        switch indexPath {
        case IndexPath(row: 1, section: 3):
            return isPickerHidden ? 0 : largeCellHeight
        case IndexPath(row: 0, section: 4):
            return infoCellHeight
        default:
            return normalCellHeight
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // FIXME: validation
        task?.name = taskNameField.text
        task?.category?.name = taskCategoryLabel.text
        task?.priority?.name = taskPriorityLabel.text
        
        if taskDeadlineField.hasText {
            task?.deadline = deadlineDatePicker.date
        } else {
            task?.deadline = nil
        }
        task?.info = taskInfoView.text
    }
}

extension TaskDetailsController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case taskDeadlineField:
            return false
        default:
            return true
        }
    } 
}
