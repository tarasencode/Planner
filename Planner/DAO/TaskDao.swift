//
//  TaskDao.swift
//  Planner
//
//  Created by oleG on 31/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import Foundation

protocol TaskDao: Crud {
    func search(text: String, sortedBy: SortType) -> [Item]
}
