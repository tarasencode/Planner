//
//  TaskListCell.swift
//  Planner
//
//  Created by oleG on 25/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import UIKit

class TaskListCell: UITableViewCell {
    
    var delegate: TaskListCellDelegate?

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskCategoryLabel: UILabel!
    @IBOutlet weak var taskDeadlineLabel: UILabel!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    
    @IBAction func checkTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.checkButtonTapped(sender: self)
    }
}
