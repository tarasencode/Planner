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
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var deleteTaskButton: UIButton!
    
    var task:Task?
    
    var isPickerHidden = true
    var isNewTask = false
    
    @IBAction func checkmarkButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        task?.completed.toggle()
    }
    
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
        if isNewTask {
            taskDeadlineField.text = Date.dateFormatter.string(from: deadlineDatePicker.date)
            isNewTask = false
        }
        
        self.view.endEditing(true)
        isPickerHidden = !isPickerHidden
        taskDeadlineField.textColor = isPickerHidden ? .black : tableView.tintColor
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let completiton: (UIAlertAction) -> Void  = {_ in self.performSegue(withIdentifier: "deleteTask", sender: sender)}
        let dialogMessage = UIAlertController(title: "Confirmation", message: "Task will be deleted. Are you sure?", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler:  completiton)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        dialogMessage.addAction(delete)
        dialogMessage.addAction(cancel)
        present(dialogMessage, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        deadlineDatePicker.date = Date().shiftDay(by: 1)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        if let task = task {
            checkmarkButton.isSelected = task.completed
            taskCategoryLabel.text = task.category?.name
            taskPriorityLabel.text = task.priority?.name
            tableView.reloadData()
            taskInfoView.text = task.info
            
            if !isNewTask {
                taskNameField.text = task.name
            } else if !taskNameField.hasText {
                taskNameField.text = task.name
                taskNameField.becomeFirstResponder()
            }
            
            if let deadline = task.deadline {
                taskDeadlineField.text = Date.dateFormatter.string(from: deadline)
                deadlineDatePicker.date = deadline
            }
            
            if isNewTask {
                deleteTaskButton.isHidden = true // FIXME: should delete section with button
            }
        }
        
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        if let count = taskNameField.text?.trimmingCharacters(in: .whitespaces).count,
                    count > 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
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
        switch segue.identifier {
        case "selectCategory":
            if let ovc = segue.destination as? OptionsController {
                ovc.task = task
                ovc.option = .category
                ovc.title = "Category"
            }
        case "selectPriority":
            if let ovc = segue.destination as? OptionsController {
                ovc.task = task
                ovc.option = .priority
                ovc.title = "Priority"
            }
        default:
            task?.name = taskNameField.text?.trimmingCharacters(in: .whitespaces)
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
