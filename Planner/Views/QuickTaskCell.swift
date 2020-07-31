//
//  QuickTaskCell.swift
//  Planner
//
//  Created by oleG on 31/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import UIKit

class QuickTaskCell: UITableViewCell {
    
    var delegate: QuickTaskCellDelegate?
    
    @IBAction func enterButtonPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
        
        if sender.hasText,
                let taskName = sender.text?.trimmingCharacters(in: .whitespaces),
                taskName.count > 0 {
            delegate?.enterButtonTapped(taskName: taskName)
            sender.text = nil
        }
    }
}
