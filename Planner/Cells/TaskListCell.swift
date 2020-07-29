//
//  TaskListCell.swift
//  Planner
//
//  Created by oleG on 25/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import UIKit

class TaskListCell: UITableViewCell {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskCategoryLabel: UILabel!
    @IBOutlet weak var taskDeadlineLabel: UILabel!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
