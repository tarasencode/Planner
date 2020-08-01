//
//  TaskDetailController.swift
//  Planner
//
//  Created by oleG on 27/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import UIKit

class TaskDetailsController: UITableViewController, UITextViewDelegate {
    
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var taskCategoryLabel: UILabel!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskDeadlineField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var deadlineDatePicker: UIDatePicker!
    @IBOutlet weak var taskInfoView: UITextView! {
        didSet {
            taskInfoView.delegate = self
        }
    }
    @IBOutlet weak var deleteTaskButton: UIButton!
    
    var task:Task!
    
    var isPickerHidden = true
    var isNewTask = false
    
    let pickerIndexPath = IndexPath(row: 1, section: 3)
    
    @IBAction func checkmarkButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        task.completed.toggle()
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
        if !taskDeadlineField.hasText {
            updateDeadlineField(date: deadlineDatePicker.date)
        }
        isPickerHidden.toggle()
        
        view.endEditing(true)
        taskDeadlineField.textColor = isPickerHidden ? .black : tableView.tintColor
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        task.deadline = nil
        taskDeadlineField.text = nil
        
        sender.isHidden = true
        isPickerHidden = true
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
    
    @IBAction func fieldEditingFinished(_ sender: UITextField) {
        if let taskName = taskNameField.text?.trimmingCharacters(in: .whitespaces),
            taskName.count > 0 {
            task.name = taskName
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        task.info = taskInfoView.text
    }
    
    // MARK: Functions
    
    func updateSaveButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = isNameFilled()
    }
    
    func updateDeadlineField(date: Date) {
        taskDeadlineField.text = Date.dateFormatter.string(from: deadlineDatePicker.date)
        task.deadline = deadlineDatePicker.date
        resetButton.isHidden = false
    }
    
    func isNameFilled() -> Bool {
        if let count = taskNameField.text?.trimmingCharacters(in: .whitespaces).count,
            count > 0 {
            return true
        } else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        deadlineDatePicker.date = Date().shiftDay(by: 1)
        
        if !isNewTask {
            navigationItem.rightBarButtonItem = nil
        } else {
            taskNameField.becomeFirstResponder()
        }
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        let activeColor = UIColor.black
        let inactiveColor = UIColor.lightGray
        
        checkmarkButton.isSelected = task.completed
        taskNameField.text = task.name
        
        if let category = task.category?.name {
            taskCategoryLabel.text = category
            taskCategoryLabel.textColor = activeColor
        } else {
            taskCategoryLabel.text = "Not set"
            taskCategoryLabel.textColor = inactiveColor
        }
        
        if let priority = task.priority?.name {
            taskPriorityLabel.text = priority
            taskPriorityLabel.textColor = activeColor
        } else {
            taskPriorityLabel.text = "Not set"
            taskPriorityLabel.textColor = inactiveColor
        }
        
        if let deadline = task.deadline {
            taskDeadlineField.text = Date.dateFormatter.string(from: deadline)
            deadlineDatePicker.date = deadline
        }
        
        taskInfoView.text = task.info ?? ""

        updateSaveButtonState()
    }
    
    // MARK: TableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let largeCellHeight: CGFloat = 200
        let infoCellHeight: CGFloat = 66
        let normalCellHeight: CGFloat = 44
        let infoIndexPath = IndexPath(row: 0, section: 4)
        
        switch indexPath {
        case pickerIndexPath:
            return isPickerHidden ? 0 : largeCellHeight
        case infoIndexPath:
            return infoCellHeight
        default:
            return normalCellHeight
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isNewTask ? 5 : 6 // hides delete section for new task
    }
    
    // MARK: Navigation
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
            return
        }
    }
}
